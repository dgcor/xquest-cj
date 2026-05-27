package benchmark

import std.fs.File
import std.io.ByteBuffer
import std.runtime.gc
import std.sort.sort
import std.time.MonoTime
import seajson.{JsonValue as SeaJsonValue, parseJson, JsonWriter as SeaJsonWriter}
import stdjson.{JsonValue, JsonKind, JsonWriter, WriteConfig}
import stdjson2.{JsonValue as JsonValue2, JsonWriter as JsonWriter2, WriteConfig as WriteConfig2}

const JSON_FILE = "large-file.json"
const WARMUP_ROUNDS = 5
const BENCHMARK_ROUNDS = 1000

func countLeavesSeaJson(value: SeaJsonValue): Int64 {
    var count = 0
    match (value) {
        case JsonArrVal(arr) => for (item in arr) {
            count += countLeavesSeaJson(item)
        }
        case JsonObjVal(obj) => for ((_, memberValue) in obj) {
            count += countLeavesSeaJson(memberValue)
        }
        case _ => count++
    }
    return count
}

func countLeavesStdJson(value: JsonValue): Int64 {
    var count = 0
    match (value.kind()) {
        case JsArray => for (item in value.asArray().getItems()) {
            count += countLeavesStdJson(item)
        }
        case JsObject => for ((_, memberValue) in value.asObject().getFields()) {
            count += countLeavesStdJson(memberValue)
        }
        case _ => count++
    }
    return count
}

func countLeavesStdJson2(value: JsonValue2): Int64 {
    var count = 0
    match (value) {
        case JsArray(arr) => for (item in arr) {
            count += countLeavesStdJson2(item)
        }
        case JsObject(obj) => for ((_, memberValue) in obj) {
            count += countLeavesStdJson2(memberValue)
        }
        case _ => count++
    }
    return count
}

func countStringLengthStdJson(value: JsonValue): Int64 {
    var strLen = 0
    match (value.kind()) {
        case JsArray => for (item in value.asArray().getItems()) {
            strLen += countStringLengthStdJson(item)
        }
        case JsObject => for ((memberName, memberValue) in value.asObject().getFields()) {
            strLen += memberName.size
            strLen += countStringLengthStdJson(memberValue)
        }
        case JsString => strLen += value.asString().getValue().size
        case _ => ()
    }
    return strLen
}

func countStringLengthSeaJson(value: SeaJsonValue): Int64 {
    var strLen = 0
    match (value) {
        case JsonArrVal(arr) => for (item in arr) {
            strLen += countStringLengthSeaJson(item)
        }
        case JsonObjVal(obj) => for ((memberName, memberValue) in obj) {
            strLen += memberName.size
            strLen += countStringLengthSeaJson(memberValue)
        }
        case JsonStrVal(str) => strLen += str.size
        case _ => ()
    }
    return strLen
}

func countStringLengthStdJson2(value: JsonValue2): Int64 {
    var strLen = 0
    match (value) {
        case JsArray(arr) => for (item in arr) {
            strLen += countStringLengthStdJson2(item)
        }
        case JsObject(obj) => for ((memberName, memberValue) in obj) {
            strLen += memberName.size
            strLen += countStringLengthStdJson2(memberValue)
        }
        case JsString(str) => strLen += str.size
        case _ => ()
    }
    return strLen
}

func writeDocumentSeaJson(writer: SeaJsonWriter, value: JsonValue): Unit {
    match (value.kind()) {
        case JsArray =>
            writer.beginArray()
            for (item in value.asArray().getItems()) {
                writeDocumentSeaJson(writer, item)
            }
            writer.endArray()
        case JsObject =>
            writer.beginObject()
            for ((memberName, memberValue) in value.asObject().getFields()) {
                writer.name(memberName)
                writeDocumentSeaJson(writer, memberValue)
            }
            writer.endObject()
        case JsBool => writer.value(value.asBool().getValue())
        case JsInt => writer.value(value.asInt().getValue())
        case JsFloat => writer.value(value.asFloat().getValue())
        case JsString => writer.value(value.asString().getValue())
        case JsNull => writer.nullValue()
    }
}

func writeDocumentStdJson(writer: JsonWriter, value: JsonValue): Unit {
    match (value.kind()) {
        case JsArray =>
            writer.startArray()
            for (item in value.asArray().getItems()) {
                writeDocumentStdJson(writer, item)
            }
            writer.endArray()
        case JsObject =>
            writer.startObject()
            for ((memberName, memberValue) in value.asObject().getFields()) {
                writer.writeName(memberName)
                writeDocumentStdJson(writer, memberValue)
            }
            writer.endObject()
        case JsBool => writer.writeValue(value.asBool().getValue())
        case JsInt => writer.writeValue(value.asInt().getValue())
        case JsFloat => writer.writeValue(value.asFloat().getValue())
        case JsString => writer.writeValue(value.asString().getValue())
        case JsNull => writer.writeNullValue()
    }
}

func writeDocumentStdJson2(writer: JsonWriter2, value: JsonValue): Unit {
    match (value.kind()) {
        case JsArray =>
            writer.startArray()
            for (item in value.asArray().getItems()) {
                writeDocumentStdJson2(writer, item)
            }
            writer.endArray()
        case JsObject =>
            writer.startObject()
            for ((memberName, memberValue) in value.asObject().getFields()) {
                writer.writeName(memberName)
                writeDocumentStdJson2(writer, memberValue)
            }
            writer.endObject()
        case JsBool => writer.writeValue(value.asBool().getValue())
        case JsInt => writer.writeValue(value.asInt().getValue())
        case JsFloat => writer.writeValue(value.asFloat().getValue())
        case JsString => writer.writeValue(value.asString().getValue())
        case JsNull => writer.writeNullValue()
    }
}

func runBenchmark(name: String, benchFunc: () -> String) {
    gc(heavy: true)

    println("\nWarming up ${name} (${WARMUP_ROUNDS} rounds)...")
    for (_ in 0..WARMUP_ROUNDS) {
        benchFunc()
    }

    println("Running ${name} (${BENCHMARK_ROUNDS} rounds)...")
    var durations = Array<Duration>(BENCHMARK_ROUNDS, repeat: Duration.Zero)
    var returnDescription = ""

    for (i in 0..BENCHMARK_ROUNDS) {
        let start = MonoTime.now()
        returnDescription = benchFunc()
        let end = MonoTime.now()
        durations[i] = end - start
    }

    durations |> sort

    // Calculate average of the fastest 95% of runs
    let p95Index = Int64(Float64(BENCHMARK_ROUNDS) * 0.95)

    var totalNs = 0
    for (i in 0..p95Index) {
        totalNs += durations[i].toNanoseconds()
    }
    if (totalNs == 0) {
        throw ArithmeticException()
    }

    let avgDurationNs = totalNs / p95Index
    let opsPerSec = 1_000_000_000 / avgDurationNs

    println("----------------------------------------")
    println("Results for: ${name}")
    println("    Return value:         ${returnDescription}")
    println("    Avg duration (P95):   ${avgDurationNs / 1_000_000} ms (${avgDurationNs} ns)")
    println("    Throughput:           ${opsPerSec} ops/sec")
    println("    Min time:             ${durations[0].toMilliseconds()} ms")
    println("    Max time (excluded):  ${durations[BENCHMARK_ROUNDS - 1].toMilliseconds()} ms")
}

main() {
    let json = String.fromUtf8(File.readFrom(JSON_FILE))
    println("Loaded JSON file (${json.size} chars)")

    let doc = JsonValue.fromStr(json)

    let seaJsonLeafCountFunc = {
        => try {
            let localDoc = parseJson(json)
            let count = countLeavesSeaJson(localDoc)
            return "${count} leaf nodes"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let stdJsonLeafCountFunc = {
        => try {
            let localDoc = JsonValue.fromStr(json)
            let count = countLeavesStdJson(localDoc)
            return "${count} leaf nodes"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let stdJson2LeafCountFunc = {
        => try {
            let localDoc = JsonValue2.fromStr(json)
            let count = countLeavesStdJson2(localDoc)
            return "${count} leaf nodes"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let seaJsonStrLenFunc = {
        => try {
            let localDoc = parseJson(json)
            let totalStrLen = countStringLengthSeaJson(localDoc)
            return "${totalStrLen} total string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let stdJsonStrLenFunc = {
        => try {
            let localDoc = JsonValue.fromStr(json)
            let totalStrLen = countStringLengthStdJson(localDoc)
            return "${totalStrLen} total string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let stdJson2StrLenFunc = {
        => try {
            let localDoc = JsonValue2.fromStr(json)
            let totalStrLen = countStringLengthStdJson2(localDoc)
            return "${totalStrLen} total string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let seaJsonWriterFunc = {
        => try {
            let writer = SeaJsonWriter(pretty: true)
            writeDocumentSeaJson(writer, doc)
            return "${writer.close().size} string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let stdJsonWriterFunc = {
        => try {
            let stream = ByteBuffer()
            let writer = JsonWriter(stream)
            writer.writeConfig = WriteConfig.pretty
            writer.writeConfig.indent = "  "
            writeDocumentStdJson(writer, doc)
            writer.flush()
            return "${String.fromUtf8(stream.bytes()).size} string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    let stdJson2WriterFunc = {
        => try {
            let stream = ByteBuffer()
            let writer = JsonWriter2(stream)
            writer.writeConfig = WriteConfig2.pretty
            writer.writeConfig.indent = "  "
            writeDocumentStdJson2(writer, doc)
            writer.flush()
            return "${String.fromUtf8(stream.bytes()).size} string length"
        } catch (e: Exception) {
            return "Exception: ${e.message}"
        }
    }

    runBenchmark("seajson (Parse + Count Leaves)", seaJsonLeafCountFunc)
    runBenchmark("stdjson (Parse + Count Leaves)", stdJsonLeafCountFunc)
    runBenchmark("stdjson2 (Parse + Count Leaves)", stdJson2LeafCountFunc)
    runBenchmark("seajson (Parse + Count String Length)", seaJsonStrLenFunc)
    runBenchmark("stdjson (Parse + Count String Length)", stdJsonStrLenFunc)
    runBenchmark("stdjson2 (Parse + Count String Length)", stdJson2StrLenFunc)
    runBenchmark("seajson (Writer Only)", seaJsonWriterFunc)
    runBenchmark("stdjson (Writer Only)", stdJsonWriterFunc)
    runBenchmark("stdjson2 (Writer Only)", stdJson2WriterFunc)

    println("\nBenchmarking complete.")
}
