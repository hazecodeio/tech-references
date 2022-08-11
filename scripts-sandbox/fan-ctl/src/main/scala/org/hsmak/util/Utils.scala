package org.hsmak.util

/**
  * Created by hsmak on 2/25/17.
  */
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