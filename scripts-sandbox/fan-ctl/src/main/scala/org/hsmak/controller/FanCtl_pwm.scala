package org.hsmak.controller

import java.io.{File, PrintWriter}

import org.hsmak.util.Utils

import scala.language.postfixOps
import scala.sys.process._

/**
  * Created by hsmak on 2/25/17.
  */

object FanCtl_pwm extends App {

  //  "sensors | grep \"Core\" | sed 's/.*:\\s*+\\(.*\\)  .*(.*/\\1/' | sed 's/[°C]//g' | sed 's/\\.0//g')"!
  val util = new Utils;

  while (true) {
    val coresTemp = Process("sensors") #| Process("grep Core")
    val streamOfLines =
      coresTemp.lazyLines
        .collect(
          {
            case line: String => line
          }
        )


    streamOfLines
      .flatMap(line => line.split(" "))
//      .flatMap(_.toStream)
      .filter(_.startsWith("+"))
      .filter(_.endsWith("°C"))
      .map(util.stripOffTheCrap(_))
    //      .foreach(println(_))

    val max = streamOfLines
      .flatMap(line => line.split(" "))
//      .flatMap(_.toStream)
      .filter(_.startsWith("+"))
      .filter(_.endsWith("°C"))
      .map(util.stripOffTheCrap(_))
      .reduce(_ max _)

    println
    println("max " + max)

    //change this if/else into a strategy design pattern
    if (max >= 35) {
      //      Process("i8kfan 2 2").lineStream.foreach(println(_))
      val pwm1 = new PrintWriter(new File("/sys/class/hwmon/hwmon3/pwm1"))
      pwm1.write("255")
      pwm1.close

      val pwm2 = new PrintWriter(new File("/sys/class/hwmon/hwmon3/pwm2"))
      pwm2.write("255")
      pwm2.close
    }
    else {
      //      var dd = Process("i8kfan 1 1").lineStream.foreach(println(_))
      val pwm1 = new PrintWriter(new File("/sys/class/hwmon/hwmon3/pwm1"))
      pwm1.write("128")
      pwm1.close

      val pwm2 = new PrintWriter(new File("/sys/class/hwmon/hwmon3/pwm2"))
      pwm2.write("128")
      pwm2.close
    }

    Thread.sleep(1000)
  }

}


/*Old Code*/


//  var tokensLoop = new Breaks;

/*tokensLoop.breakable {
  while (tokenizer.hasMoreTokens) {
    var token = tokenizer.nextToken();

    if (token.startsWith("+")) {
      println(u.tok(token))
      tokensLoop.break
    }

    /*if (token.startsWith("+")) {
      var l = token
        .filter(t => t != '+')
        .filter(t => t != '°')
        .filter(t => t != 'C')
        .collect(
          {
            case i: Char => i
          }
        )
      println(l.toDouble.toInt)
      //        token = token.replaceAll("-d", "")
      //        println(token.toInt)
      loop.break
    }*/
  }
}*/

//  while(true) {
//    var process = Process("sensors").lineStream
//    process.foreach(s => println(s))
//    Thread.sleep(1000)
//  }