import std.collection.ArrayList
import std.process.{launch, ProcessRedirect}
import std.fs.{Directory, exists, FileInfo, Path, removeIfExists}

@When[os == "Windows"]
private const CHECK_CMD = "where"
@When[os != "Windows"]
private const CHECK_CMD = "which"
@When[os == "Windows"]
private const IS_WINDOWS = true
@When[os != "Windows"]
private const IS_WINDOWS = false
private const LIBRARY_PATH = "./physfs"
private const LIBRARY_NAME = "physfs4cj"
private let OUTPUT_LIBRARY_NAME = "lib${LIBRARY_NAME}.a"
private let INPUT_LIBRARIES_PATH = Path(LIBRARY_PATH).join("build/lib")
private let INPUT_LIBRARIES = ["libphysfs.a"]

private func commandExists(name: String): Bool {
    let process = launch(
        CHECK_CMD,
        name,
        stdOut: ProcessRedirect.Discard,
        stdErr: ProcessRedirect.Discard
    )
    return process.wait() == 0
}

private func runCommand(cmd: String, args: Array<String>, cwd!: ?Path = None): Int64 {
    let process = launch(
        cmd,
        args,
        workingDirectory: cwd
    )
    return process.wait()
}

private func stagePreBuild(): Int64 {
    if (!commandExists("cmake")) {
        println("Error: 'cmake' not found. Please install CMake.")
        return 1
    }

    let generatorArgs = match {
        case IS_WINDOWS => match {
            case commandExists("ninja") => ["-G", "Ninja"]
            case commandExists("mingw32-make") => ["-G", "MinGW Makefiles"]
            case _ =>
                println("Error: Windows requires 'ninja' or 'mingw32-make' to build with Clang/GCC.")
                return 1
        }
        case _ => match {
            case commandExists("ninja") => ["-G", "Ninja"]
            case _ => Array<String>()
        }
    }

    let preset = match {
        case commandExists("clang") => "clang"
        case commandExists("gcc") => "gcc"
        case _ =>
            println("Error: Neither 'clang' nor 'gcc' found.")
            return 1
    }

    let configureArgs = generatorArgs.concat(["--preset", preset])
    let ret = runCommand("cmake", configureArgs, cwd: Path(LIBRARY_PATH))
    if (ret != 0) {
        return ret
    }
    return runCommand("cmake", ["--build", "--preset", preset], cwd: Path(LIBRARY_PATH))
}

private func stagePostBuild(): Int64 {
    let tempDir = INPUT_LIBRARIES_PATH.join("temp_obj_merge")
    let outputLibPath = Path("target/release/${LIBRARY_NAME}")
    let outputLibFile = Path("${outputLibPath}/${OUTPUT_LIBRARY_NAME}")

    if (!exists(outputLibFile)) {
        println("Output library ${outputLibFile} not found. Skipping merge.")
        return 0
    }

    println("Output library found. Proceeding with merge...")

    removeIfExists(tempDir, recursive: true)
    Directory.create(tempDir, recursive: true)

    for (libName in INPUT_LIBRARIES) {
        let libPath = INPUT_LIBRARIES_PATH.join(libName)
        if (!exists(libPath)) {
            println("Error: Input library '${libName}' not found at ${libPath.toString()}")
            return 1
        }
        let extractArgs = ["x", "../${libName}"]
        let ret = runCommand("ar", extractArgs, cwd: tempDir)
        if (ret != 0) {
            println("Error: Failed to extract ${libName}")
            return ret
        }
    }

    let objFiles = ArrayList<String>()
    try {
        Directory.walk(tempDir) {
            info: FileInfo =>
                let filePath = info.path.toString()
                if (info.isRegular() && (filePath.endsWith(".o") || filePath.endsWith(".obj"))) {
                    objFiles.add(filePath)
                }
                return true
        }
    } catch (ex: Exception) {
        println("Error scanning extracted files: ${ex.message}")
        return 1
    }

    if (objFiles.isEmpty()) {
        println("Error: No object files found after extraction.")
        return 1
    }

    println("Merging ${objFiles.size} object files into ${OUTPUT_LIBRARY_NAME}...")

    let createArgs = ["rcs", OUTPUT_LIBRARY_NAME].concat(objFiles.toArray())
    let ret = runCommand("ar", createArgs, cwd: outputLibPath)
    removeIfExists(tempDir, recursive: true)
    if (ret == 0) {
        println("Successfully updated ${OUTPUT_LIBRARY_NAME}")
    }
    return ret
}

main(args: Array<String>): Int64 {
    match (args[0]) {
        case "pre-build" => stagePreBuild()
        case "post-build" => stagePostBuild()
        case _ => 0
    }
}
