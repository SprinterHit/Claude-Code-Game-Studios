class_name ChartStyle
extends RefCounted
## Shared ink, paper, and type for the one sea chart.


const INK := Color("241c16")
const PAPER := Color("f4ecd8")
const PAPER_DEEP := Color("e5d7bc")
const VERMILION := Color("c24b2a")
const SEA_INK := Color("16343a")
const CURRENT := Color(0.11, 0.40, 0.50, 0.82)
const CURRENT_EDGE := Color(0.05, 0.24, 0.32, 0.55)
const CURRENT_STREAK := Color(0.90, 0.97, 0.95, 0.88)
const WIND := Color("d4653a")
const LAND := Color("d2b67a")
const HILL := Color("7d9458")
const SHORE := Color("efe4c8")
const SAIL := Color("f7f1e4")
const HULL := Color("241c16")
const WAKE := Color(0.93, 0.95, 0.90, 0.55)
const TRACK := Color(0.97, 0.94, 0.86, 0.9)

const FONT: FontFile = preload("res://assets/fonts/wqy-microhei.ttc")

const COAST_NAME := "向风群岛"
const GEOGRAPHY_REASON := "东北信风与加那利海流把船送向西，所以向风群岛落在这条航线的西端。"
const MISSED_LINE := "这一趟失败：船被风流带过了海岸"
const SUPPLY_LINE := "这一趟失败：补给已尽，陆地仍未出现"
const HINT_LINE := "触摸海面，改航向"
const AGAIN_LINE := "再走一趟"
const WIND_NOTE := "风"
const CURRENT_NOTE := "流"
