class_name ChartStyle
extends RefCounted
## Shared ink, paper, and type for the one sea chart.


const INK := Color("3a2a22")
const PAPER := Color("fff6e8")
const PAPER_DEEP := Color("f0dcc0")
const VERMILION := Color("e14b3c")
const SEA_INK := Color("14586a")
const CURRENT := Color(0.13, 0.58, 0.72, 0.9)
const CURRENT_EDGE := Color(0.06, 0.32, 0.46, 0.55)
const CURRENT_STREAK := Color(0.86, 0.98, 0.97, 0.92)
const CURRENT_LABEL := Color("0e4c5c")
const WIND := Color("f06a3a")
const WIND_LIGHT := Color("ffb089")
const LAND := Color("f2d08a")
const HILL := Color("5eae52")
const HILL_LIGHT := Color("8ed46a")
const SHORE := Color("f8e7c4")
const GRASS := Color("7dcc68")
const GRASS_DEEP := Color("4ea24b")
const WOOD := Color("8a4e32")
const WOOD_DARK := Color("4e2c1e")
const WOOD_LIGHT := Color("d09258")
const DECK := Color("f0d7a4")
const GOLD := Color("f2c14e")
const SAIL := Color("fff8ee")
const SAIL_SHADE := Color("f3d7ae")
const SAIL_LINE := Color("c9a27a")
const HULL := Color("4e2c1e")
const WAKE := Color(0.95, 0.99, 0.98, 0.72)
const TRACK := Color(1.0, 0.97, 0.9, 0.95)

const FONT: FontFile = preload("res://assets/fonts/wqy-microhei.ttc")

const COAST_NAME := "向风群岛"
const GEOGRAPHY_REASON := "东北信风与加那利海流把船送向西，所以向风群岛落在这条航线的西端。"
const MISSED_LINE := "这一趟失败：船被风流带过了海岸"
const SUPPLY_LINE := "这一趟失败：补给已尽，陆地仍未出现"
const HINT_LINE := "触摸海面，改航向"
const AGAIN_LINE := "再走一趟"
const WIND_NOTE := "风"
const CURRENT_NOTE := "流"
