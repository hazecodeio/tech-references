#!/usr/bin/env scala

import scala.language.postfixOps
import scala.sys.process._

/**
  * Created by hsmak on 2/25/17.
  */

object FanCtl_i8kfan extends App {

  println("FanCtl has started monitoring your CPU temperature...")

  val debug = args.filter(_.startsWith("-d="))
    .headOption.map(_.substring(3))
    .filter(_.toLowerCase.startsWith("t"))
    .map(_ => true)
    .getOrElse(false)

  val MAX = 35 // ToDo: change to env variable
//  val thresholdGap = 2 // ToDo: To be removed

  val util = new Utils
  var prevThreshold = TempThreshEnum.LOW
  var thresholdChange: Boolean = true

  var currentThreshold = TempThreshEnum.HIGH // move this line outside the loop

  while (true) {
    val coresTemp = Process("sensors") #| Process("grep Core") // call system commands
    val streamOfLines =
      coresTemp.lazyLines
        .collect(
          {
            case line: String => line
          }
        )

    streamOfLines
      .flatMap(line => line.split(" "))
//      .flatMap(_.to(LazyList)) // ToDo: unnecessary
      .filter(_.startsWith("+"))
      .filter(_.endsWith("°C"))
      .map(util.stripOffTheCrap(_))
    //      .foreach(println(_))

    val cpuTemp = streamOfLines
      .flatMap(line => line.split(" ")) //split each line on the space, so it will return another StreamOfString[]; precisely Stream<String[]>
      //.flatMap(_.toStream) // flatten Stream<String[]> into Stream<Stream<String>>, and then into a combined Stream<String> // ToDo: unnecessary
      .filter(_.startsWith("+")) // filters on each line and each word per line
      .filter(_.endsWith("°C"))
      .map(util.stripOffTheCrap(_)) // could the use of head/headoption work before calling map?
      .reduce(_ max _)

    if (debug) {
      println
      println("cpuTemp " + cpuTemp)
    }

    //
    /**
     * ToDo:
     *  - Fix:      when cpuTemp is already high during bootup and initial run, fan speed remained low
     *              i.e. cpuTemp is already >= MAX
     *  - Refactor: move this logic to a method
     */
    if (cpuTemp >= MAX)
      currentThreshold = TempThreshEnum.HIGH
    else if (cpuTemp < MAX)
      currentThreshold = TempThreshEnum.LOW


    if (currentThreshold == prevThreshold)
      thresholdChange = false
    else
      thresholdChange = true

    if (debug) {
      println(currentThreshold)
      println(thresholdChange)
    }
    prevThreshold = currentThreshold

    //change this if/else into a strategy design pattern
    if (cpuTemp >= MAX && thresholdChange) {
      val lineStream = Process("i8kfan 2 2").lazyLines
      if (debug)
        lineStream.foreach(println(_))
    }
    else if (cpuTemp < MAX && thresholdChange) {
      val lineStream = Process("i8kfan 1 1").lazyLines
      if (debug)
        lineStream.foreach(println(_))
    }

    Thread.sleep(1000)
  }
}

object TempThreshEnum extends Enumeration {
  val HIGH, LOW = Value
}

class Utils {
  def stripOffTheCrap(token: String): Int = {
    val temperatureInStr = token
      .filter(t => t != '+')
      .filter(t => t != '°')
      .filter(t => t != 'C')
      .collect(
        {
          case i: Char => i
        }
      )
    return temperatureInStr.toDouble.toInt
  }

  def extractTempFromLine(line: String): String = {
    return ""
  }
}
