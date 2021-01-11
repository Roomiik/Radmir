#IfWinActive GTA:SA:MP 
#SingleInstance Force 
#NoEnv 
#IfWinActive, ahk_exe gta_sa.exe
ListLines Off 
SetBatchLines -1 
chatlog := A_MyDocuments "\GTA San Andreas User Files\SAMP\chatlog.txt" 
FileDelete, %chatlog% 
Words = (kick|mute|jail|hp|unmute|unjail|sban|spcar|ban|warn|skick|o|unban|unwarn|offjail|banip|offban|offwarn|okay|slap|sp) 

if (A_IsAdmin = false) {
    Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel
}

;//= Инклуды
#include samp-udf.ahk
#include CP.ahk
;//=

ListLines Off
SetBatchLines -1
#SingleInstance, force
#NoEnv
StringCaseSense, Locale



; === Глобальные переменные
global chatlog 				:= A_MyDocuments "/RADMIR CRMP User Files/SAMP/chatlog.txt" 
global screens 				:= A_MyDocuments "/RADMIR CRMP User Files\SAMP\screens" 
global config 				:= A_ScriptDir "\other\config.ini"
; ===

global string_zet

; ===
global totalans 			:= 0
global totaljail 			:= 0
global totalkick 			:= 0
global totalmute 			:= 0
global totalz 				:= 0
global totalrmute 			:= 0
global totalban 			:= 0
global totalwarn 			:= 0
global z := 0
global id_z_enterprize 		:= 0
global name_z_enterprize 	= ""
global idz_z_enterprize 	:= 0
; ===

checkversion(2)

IfWinNotExist,  GTA:SA:MP
{
    msgbox, Ожидается открытие игры RADMIR CRMP в течении минуты...
    process, Wait, gta_sa.exe, 60
    Loop
    {
        if (ErrorLevel == 0) {
            msgbox, Процесс игры RADMIR CRMP не был найден`n`nСкрипт завершает работу...
            exitapp
        }
		else {
			SetTimer, start, 50
			break
		}

    }
}
else {
	SetTimer, start, 50
}

global get_index
global get_line_of_index
global get_dialog_text
global get_online_of_cmdget

IfNotExist, other
{
    FileCreateDir, other
    IfNotExist, other\done
    {
        FileCreateDir, other\done

        IfNotExist, %config%
        {
            fileappend, , %config%
            IniWrite, 1, %config%, config, all
            IniWrite, 300, %config%, config, normareport
            IniWrite, 20, %config%, config, normajail
            IniWrite, 50, %config%, config, normakick
            IniWrite, 5, %config%, config, normamute
            IniWrite, 50, %config%, config, normaz
            IniWrite, 0, %config%, config, autospec
            IniWrite, 0, %config%, config, helpz
            IniWrite, 0, %config%, config, is_the_dialogue_open
            IniWrite, 0, %config%, config, autor
            IniWrite, 0, %config%, config, copys
        }
    }
}

; === Регистрация команд
CMD.Register("athelp","athelp") ; +
CMD.Register("atinfo","atinfo") ; +
CMD.Register("clearst","clearst") ; +
CMD.Register("nakol","nakol") ; +
CMD.Register("admlvl2","admlvl2") ; +
CMD.Register("admlvl3","admlvl3") ; +
CMD.Register("admlvl4","admlvl4") ; +
CMD.Register("auto0","auto0") ; +
CMD.Register("auto1","auto1") ; +
CMD.Register("auto2","auto2") ; +
CMD.Register("auto3","auto3") ; +
CMD.Register("auto4","auto4") ; +
CMD.Register("auto5","auto5") ; +
CMD.Register("auto6","auto6") ; +
CMD.Register("gunid","gunid") ; +
CMD.Register("napom","napom") ; +
CMD.Register("napom1","napom1") ; +
CMD.Register("napom2","napom2") ; +
CMD.Register("gosinfo","gosinfo") ; +
CMD.Register("gosinfo1","gosinfo1") ; +
CMD.Register("gosinfo2","gosinfo2") ; +
CMD.Register("gosinfo3","gosinfo3") ; +
CMD.Register("gosinfo4","gosinfo4") ; +
CMD.Register("gosinfo5","gosinfo5") ; +
CMD.Register("gosinfo6","gosinfo6") ; +
CMD.Register("admnakaz","admnakaz") ; +
CMD.Register("admnakaz1","admnakaz1") ; +
CMD.Register("admnakaz2","admnakaz2") ; +
CMD.Register("admnakaz3","admnakaz3") ; +
CMD.Register("admnakaz4","admnakaz4") ; +
CMD.Register("admnakaz5","admnakaz5") ; +
CMD.Register("pravilabiz","pravilabiz") ; +
CMD.Register("pravilacapt","pravilacapt") ; +
; === Регистрация команд Sup
CMD.Register("helpz","helpz") ; +
CMD.Register("find_helper_key","find_helper_key") ; +
CMD.Register("helper_use","helper_use") ; +
exit
;//=

; === Команды ===

helpz() {
	IniRead, helpz, %config%, config, helpz, 0
	helpz := !helpz 
	IniWrite, %helpz%, %config%, config, helpz 
	addChatMessage("{ff87cc}• Информация: {ffffff}Функция {FF8129}helpZ {ffffff}была: " (helpz ? "{33FF63}активированна" : "{FF4933}деактивированна"))
	SetTimer, helperz, % (helpz ? 50 : "off") 
	SetTimer, helper_find, % (helpz ? 50 : "off") 
}
return

helperz() {
	if ( isDialogOpen() = 1 ){
		if ( getDialogCaption() = "{3399FF}Информация о запросе" ) {
			IniRead, is_the_dialogue, %config%, config, is_the_dialogue_open, 0
			if (is_the_dialogue != 1) {
				IniWrite, 1, %config%, config, is_the_dialogue_open 
				SetTimer, helper_use, 50
			}
		}
		else {
			IniWrite, 0, %config%, config, is_the_dialogue_open 
		}
	}
	else {
		IniWrite, 0, %config%, config, is_the_dialogue_open 
	}
}
return

helper_use() {
	IniRead, is_the_dialogue, %config%, config, is_the_dialogue_open, 0
	
	if (is_the_dialogue = 1) {
		; == Код ==
		Loop, Read, other\helper_z.txt
		{
			if (RegExMatch(A_LoopReadLine, "(.*)\:(.*)", out_text)) {
				string_read := getDialogLine(9)
				IfInString, string_read, %out_text1%
				{
					addChatMessage("{ff87cc}• Информация: {ffffff}Найден вариант ответа: {FF8129}" out_text2)
					SendMessage, 0x50,, 0x4190419,, A
					sendinput, %out_text2%
				}
			}
		}
		;
		SetTimer, helper_use, off
	}
}
return

helper_find() {
	if ( isDialogOpen() = 1 ){
		if ( getDialogCaption() = "{3399FF}Информация о запросе" ) {
			string_zetty := getDialogLine(9)
			regexmatch(string_zetty, "\}(.*)", out_str_z)
			string_zet := out_str_z1
		}
	}
}
return

find_helper_key() {
	IniRead, help_find, %config%, config, help_find, 0
	help_find := !help_find 
	IniWrite, %help_find%, %config%, config, help_find 
	addChatMessage("{ff87cc}• Информация: {ffffff}Функция {FF8129}helperFind` {ffffff}была: " (help_find ? "{33FF63}активированна" : "{FF4933}деактивированна"))
	SetTimer, helper_find_activ, % (help_find ? 50 : "off") 
}
return

helper_find_activ() {
	fileread, find_z_read, %chatlog%
	fileread, none_double, other\helper_z.txt
	
	if (regexmatch(find_z_read, "Текст ответа: (.*)", out_find)) {
		IfInString, none_double, %string_zet%:%out_find1%
			sleep 1
		else {
			fileappend, %string_zet%:%out_find1%`n, other\helper_z.txt
			addChatMessage("{ff87cc}• Информация: {ffffff}На вопрос: {FF8129}" string_zet)
			addChatMessage("{ff87cc}• Информация: {ffffff}Был сохранен ответ: {FF8129}" out_find1)
			restorelog()
		}
	}
}
return


athelp() {
	
	IniRead, all, %config%, config, all, 0
	IniRead, helpz, %config%, config, helpz, 0
	IniRead, help_find, %config%, config, help_find, 0
	
	if ( all == 1 ) {
		all_str = {33FF63}включено {FFFFFF}(10ms)
	}
	else {
		all_str = {FF4933}выключено
	}
	
	if ( helpz == 1 ) {
		helpz_str = {33FF63}включено {FFFFFF}(10ms)
	}
	else {
		helpz_str = {FF4933}выключено
	}
	
	if ( help_find == 1 ) {
		help_find_str = {33FF63}включено {FFFFFF}(10ms)
	}
	else {
		help_find_str = {FF4933}выключено
	}
	
	string_help = 
	(

{FF8129}/atinfo {ffffff}- Посмотреть административную статистику
{FF8129}/clearst {ffffff}- Обнулить административную статистику
{FF8129}ALT +R {ffffff}- Перезагрузить скрипт

{FF8129}/nakol {ffffff}- Информация про наколки
{FF8129}/gunid {ffffff}- Информация про оружия
{FF8129}/faqtxt /faqjail /faqwarn /faqmute  {ffffff}- Для быстрого ввода из atools2

Правила для гос. структур
{FF8129}/gosinfo{ffffff}- Правительство 	{FF8129}/gosinfo1{ffffff}- МВД 		{FF8129}/gosinfo2{ffffff}- МО
{FF8129}/gosinfo3{ffffff}- МЗ			{FF8129}/gosinfo4{ffffff}- ТРК			{FF8129}/gosinfo5{ffffff}- МЧС
{FF8129}/gosinfo6{ffffff}- ФСИН

{FF8129}/auto0 {ffffff}- Мото/Вело класс	{FF8129}/auto1 {ffffff}- Низкий класс
{FF8129}/auto2 {ffffff}- Средний класс	{FF8129}/auto3 {ffffff}- Высокий класс
{FF8129}/auto4 {ffffff}- Водный класс		{FF8129}/auto5 {ffffff}- Воздушный класс	
{FF8129}/auto6 {ffffff}- Доп класс

{FF8129}/pravilabiz {ffffff}- Правила захвата/войны за бизнес
{FF8129}/pravilacapt {ffffff}- Правила проведения войны за территорию

{FF8129}/admnakaz {ffffff}- Информация о наказаниях | Kick и Блокировка чата
{FF8129}/admnakaz1 {ffffff}- Информация о наказаниях | Деморган
{FF8129}/admnakaz2 {ffffff}- Информация о наказаниях | Варн
{FF8129}/admnakaz3 {ffffff}- Информация о наказаниях | Блокировка аккаунта
{FF8129}/admnakaz4 {ffffff}- Информация о наказаниях | В зависимости от тяжести нарушения

{FF8129}/admlvl2 {ffffff}- Информация о командах администратора 2lvl
{FF8129}/admlvl3 {ffffff}- Информация о командах администратора 3lvl
{FF8129}/admlvl4 {ffffff}- Информация о командах администратора 4lvl


			
{FF8129}Подсчет наказаний и репортов: `t{ffffff}%all_str%
	
	)
	ShowDialog(0, "{FFEE00}Помощь по скрипту", string_help, "Закрыть")
}
return

;//= Окно наколки
nakol() {
	
	str_dialog_nakol =
	
	(
{FF8129}1. {FFFFFF}Мужик - {FF8129}3 {FFFFFF}часа - {FF8129}50 {FFFFFF}рублей
{FF8129}2. {FFFFFF}Козел - {FF8129}6 {FFFFFF}часов - {FF8129}100 {FFFFFF}рублей
{FF8129}3. {FFFFFF}Пацан - {FF8129}9 {FFFFFF}часов - {FF8129}150 {FFFFFF}рублей - {FF8129}9-ка{FFFFFF} в банде
{FF8129}4. {FFFFFF}Бык - {FF8129}12 {FFFFFF}часов - {FF8129}200 {FFFFFF}рублей
{FF8129}5. {FFFFFF}Барыга - {FF8129}15 {FFFFFF}часов - {FF8129}250 {FFFFFF}рублей
{FF8129}6. {FFFFFF}Вор - {FF8129}18 {FFFFFF}часов - {FF8129}300 {FFFFFF}рублей
{FF8129}7. {FFFFFF}Пахан - {FF8129}21 {FFFFFF}час - {FF8129}350 {FFFFFF}рублей - {FF8129}/gang_create
{FF8129}8. {FFFFFF}Блатной - {FF8129}24 {FFFFFF}часа - {FF8129}400 {FFFFFF}рублей
{FF8129}9. {FFFFFF}Вор в законе - {FF8129}27 {FFFFFF}часов - {FF8129}450 {FFFFFF}рублей
	)
	
	showdialog(0, "Наколки", str_dialog_nakol, "Закрыть")
}
return
;//= Окно конец

;//= Окно 2лвл
admlvl2() {
	
	str_dialog_admlvl2 =
	
	(
{FF8129}/mute {FFFFFF}дать затычку 
{FF8129}/rmute {FFFFFF}дать затычку репорта
{FF8129}/v_mute {FFFFFF}дать затычку голос чат 
{FF8129}/jail {FFFFFF}посадить в тюрьму 
{FF8129}/kick {FFFFFF}кикнуть  
{FF8129}/unjail {FFFFFF}выпустить из тюрьмы 
{FF8129}/goto {FFFFFF}телепортироваться к игроку 
{FF8129}/alock {FFFFFF}открыть любое ТС
{FF8129}/money {FFFFFF}инфа по деньгам у игрока 
{FF8129}/hp {FFFFFF}установить ХП только себе(!) 
{FF8129}/spcar {FFFFFF}заспавнить т/с 
{FF8129}/getcar {FFFFFF}телепортировать к себе авто
{FF8129}/gangs {FFFFFF}вступить в банду из предложенного списка на сервере 
{FF8129}/tdo_delete {FFFFFF}удалить надпись /tdo 
{FF8129}/ac {FFFFFF}присоединится к чату саппортов 
{FF8129}/stats {FFFFFF}просмотр статистики игрока в онлайне  
{FF8129}/fixcar {FFFFFF}починить автомобиль  
{FF8129}/stats {FFFFFF}просмотр предметов игрока  
{FF8129}/a_view_items {FFFFFF}просмотр статистики игрока в онлайне  
	)
	
	showdialog(0, "Команды администратора 2lvl", str_dialog_admlvl2, "Закрыть")
}
return
;//= Окно конец

;//= Окно 3лвл
admlvl3() {
	
	str_dialog_admlvl3 =
	
	(
{FF8129}/respv {FFFFFF}Респавн автомабилей в радиусе 
{FF8129}/gotocar {FFFFFF}телепортироваться к авто 
{FF8129}/offban {FFFFFF}забанить игрока в оффлайн 
{FF8129}/offwarn {FFFFFF}выдать предупреждение оффлайн 
{FF8129}/warn {FFFFFF}выдать предупреждение игроку 
{FF8129}/ban {FFFFFF}забанить игрока 
{FF8129}/skick {FFFFFF}тихо кикнуть игрока 
{FF8129}/okay {FFFFFF}одобрить заявку на смену ника 
{FF8129}/gethere {FFFFFF}телепортировать к себе игрока 
{FF8129}/biz {FFFFFF}телепортироваться к бизнесу 
{FF8129}/house {FFFFFF}телепортироваться к дому 
{FF8129}/ent {FFFFFF}телепортироваться к подьезду 
{FF8129}/ga {FFFFFF}телепортироваться к гаражу 
{FF8129}/ip {FFFFFF}ип игрока 
{FF8129}/lip {FFFFFF}зарегестрированые аккаунту на данный ip 
{FF8129}/skin {FFFFFF}временный скин
{FF8129}/fixcarall {FFFFFF}починка автомобилей в радиусе 
{FF8129}/ears {FFFFFF}прослушка СМС 
{FF8129}/hp {FFFFFF}установить ХП игроку(!) 
{FF8129}/offjail {FFFFFF}выдать игроку джайл в оффлайне 
{FF8129}/spcars {FFFFFF}заспавниит всё авто 
{FF8129}/a_boombox_delete {FFFFFF}удалить boombox игрока
	)
	
	showdialog(0, "Команды администратора 3lvl", str_dialog_admlvl3, "Закрыть")
}
return
;//= Окно конец

;//= Окно 4лвл
admlvl4() {
	
	str_dialog_admlvl4 =
	
	(
{FF8129}/templeader {FFFFFF}назначить себя врем.лидером
{FF8129}/sban {FFFFFF}забанить на всегда тихим баном ( без вывода в общий чат ) 
{FF8129}/unrban {FFFFFF}разбан IP 
{FF8129}/soffban {FFFFFF}забанить игрока в оффлайне без "лишнего шума" 
{FF8129}/unwarn {FFFFFF}снять варн (Игроку в онлайне по ID) 
{FF8129}/msg {FFFFFF}писать в общий чат 
{FF8129}/fine_park {FFFFFF}Отправить машину на штраф стоянку 
{FF8129}/setweather (/sw) {FFFFFF}установить погоду 
{FF8129}/settime (/st) {FFFFFF}установить время 
{FF8129}/setpoint {FFFFFF}установить точку телепорта 
{FF8129}/tpmark {FFFFFF}телепортироваться на установленую точку 
{FF8129}/setfuel {FFFFFF}заправить ТС 
{FF8129}/veh 0 0 {FFFFFF}создать авто для адм(цвет) (цвет)
{FF8129}/veс 0 0 0 {FFFFFF}создать авто для игрока(цвет) (цвет) 0
{FF8129}/hpall {FFFFFF}выдать ХП в указаном радиусе 
{FF8129}/settp {FFFFFF}открыть точку телепорта для игроков(!) 
{FF8129}/get {FFFFFF}просмотреть всю информацию об аккаунте 
{FF8129}/mp_tp {FFFFFF}создать точку телепорта на МП 
{FF8129}/mp_gun {FFFFFF}выдача оружия командам на МП 
{FF8129}/mp_skin {FFFFFF}скины команд на МП 
{FF8129}/mp_team {FFFFFF}кол-во команд на МП 
{FF8129}/mp_get {FFFFFF}телепортировать к себе команду
	)
	
	showdialog(0, "Команды администратора 4lvl", str_dialog_admlvl4, "Закрыть")
}
return
;//= Окно конец

;//= Окно наказаний
admnakaz() {
	
	str_dialog_admnakaz =
	
	(
{0000FF}Kick

{FFFFFF}Gun in ZZ | {FF8129}Kick.
{FFFFFF}Бег по дороге | {FF8129}Kick.
{FFFFFF}Афк на дороге | {FF8129}Kick.
{FFFFFF}Запрещено использовать ники, содержащие Нецензурные или оскорбительные слова | {FF8129}Kick .
{FFFFFF}Запрещено использовать чужие (Уже кем-то занятые) ники | {FF8129}Kick

{0000FF}Блокировка чата

{FFFFFF}Оскорбление в репорт | {FF8129}Блокировка репорта 120-360 минут.
{FFFFFF}Мат/Капс в репорт | {FF8129}Блокировка репорта 30-120 минут.
{FFFFFF}Оффтоп в /d,/dd | {FF8129}Блокировка чата на 60 минут.
{FFFFFF}Оффтоп в репорт | {FF8129}Блокировка репорта на 30 минут.
{FFFFFF}NonRP /edit | {FF8129}Блокировка чата на 120 минут.
{FFFFFF}Казино в Деморгане | {FF8129}Блокировка чата на 60 минут.
{FFFFFF}Бред в /me|/do|/try | {FF8129}Блокировка чата на 30 минут.
{FFFFFF}Оскорбление/Мат в ООС чат | {FF8129}Блокировка чата на 60-120 минут.
{FFFFFF}Флуд | {FF8129}Блокировка чата на 30 минут.
{FFFFFF}MG | {FF8129}Блокировка чата на 60 минут ( для 20+ уровня 120 минут ) 
{FFFFFF}Бред в голосовой чат | {FF8129}Блокировка голосового чата на 30 минут.
{FFFFFF}Caps в ООС чат | {FF8129}Блокировка чата на 30 минут.
{FFFFFF}Транслит в IC чат | {FF8129}Блокировка чата на 30 минут.
{FFFFFF}Выдача себя за членов администрации | {FF8129}Блокировка чата на 360 минут.
{FFFFFF}Оскорбление администрации | {FF8129}Блокировка чата от 120 минут.
	)
	
	showdialog(0, "Общая выдача наказаний", str_dialog_admnakaz, "Закрыть")
}
return

admnakaz1() {
	
	str_dialog_admnakaz1 =
	
	(
{0000FF}Деморган

{FFFFFF}RK | {FF8129}Деморган на 120 минут.
{FFFFFF}DmCar | {FF8129}Деморган на 60 минут.
{FFFFFF}Гражданский на территории ВЧ | {FF8129}Деморган на 60 минут.
{FFFFFF}Стрельба в интерьере | {FF8129}Деморган на 60 минут.
{FFFFFF}DB | {FF8129}Деморган на 60 минут.
{FFFFFF}DM | {FF8129}Деморган на 120 минут. ( /blow не исключение )
{FFFFFF}PG | {FF8129}Деморган на 120 минут.
{FFFFFF}ЕПП | {FF8129}Деморган на 60 минут. ( Исключение: По лесу на внедорожниках )
{FFFFFF}Дым | {FF8129}Деморган на 30 минут.
{FFFFFF}Срез | {FF8129}Деморган на 30 минут.
{FFFFFF}NonRP Gun | {FF8129}Деморган 120 минут.
{FFFFFF}Красный | {FF8129}Деморган на 60 минут. (С 0:00-6:00 по /c 060 разрешается ездить на красный свет светофора)
{FFFFFF}Drugs in ZZ | {FF8129}Деморган на 30 минут.
{FFFFFF}Встречка | {FF8129}Деморган 30-120 минут.
{FFFFFF}NonRP угон | {FF8129}Деморган на 30 минут.
{FFFFFF}Крыша авто | {FF8129}Деморган 30-60 минут.
{FFFFFF}NonRP казино (Прыжки по столам, попытка ДМ-а, анимации перед ставками ( от двух анимаций) | {FF8129}Деморган на 60 минут.
{FFFFFF}Прокрутка оружия | {FF8129}Деморган на 30 минут.
{FFFFFF}WH ( исключение: BMX ) | {FF8129}Деморган на 10 минут.
{FFFFFF}NonRP /drugs|/healme|/mask | {FF8129}Деморган 60-120 минут.
{FFFFFF}Езда с пробитыми колесами | {FF8129}Деморган на 30 минут.
{FFFFFF}NonRP медик ( лечение в холе/коридоре ) | {FF8129}Деморган на 30 минут.
{FFFFFF}Провокация на DM | {FF8129}Деморган на 10 минут. (Примечание: Оскорбления не являются провокацией для убийства!)
{FFFFFF}NonRP кач скиллов ( Не в специально отведенных для стрельбы местах ) | {FF8129}Деморган 60-120 минут.
{FFFFFF}Прогул рабочего дня 1-5 ранги | {FF8129}Деморган 60 минут.
{FFFFFF}Прогул рабочего дня 5+ ранги  | {FF8129}Деморган 120 минут.
	)
	
	showdialog(0, "Общая выдача наказаний", str_dialog_admnakaz1, "Закрыть")
}
return

admnakaz2() {
	
	str_dialog_admnakaz2 =
	
	(
{0000FF}Варн

{FFFFFF}SK | {FF8129}Warn.
{FFFFFF}TK | {FF8129}Warn.
{FFFFFF}Таран | {FF8129}Warn.
{FFFFFF}DB in ZZ | {FF8129}Warn.
{FFFFFF}/tie|/bag в общественных местах или ZZ | {FF8129}Warn.
{FFFFFF}Антифраг | {FF8129}Warn.
{FFFFFF}DM in ZZ | {FF8129}Warn. ( /blow не исключение )
{FFFFFF}Антикапт | {FF8129}Warn.
{FFFFFF}DM в интерьере | {FF8129}Warn.
{FFFFFF}NonRP /escort|/givelic|/arrest| | {FF8129}Warn.
{FFFFFF}Уход от РП процесса | {FF8129}Warn.
{FFFFFF}+С/Отводы/Сбив анимаций | {FF8129}Warn.
{FFFFFF}Массовый ДМ ( Целенамеренное убийство невинных игроков ( от 3-х убийств ) | {FF8129}Warn/Ban.
{FFFFFF}Уход в интерьер от смерти | {FF8129}Warn.
{FFFFFF}Во время боя запрещен Drugs/Healme ( после окончания боя разрешено через 30 секунд ) | {FF8129}Warn при нарушении данного пункта.
	)
	
	showdialog(0, "Общая выдача наказаний", str_dialog_admnakaz2, "Закрыть")
}
return

admnakaz3() {
	
	str_dialog_admnakaz3 =
	
	(
{0000FF}Блокировка аккаунта

{FFFFFF}Создание фейкового аккаунта публичной личности | {FF8129}Блокировка аккаунта навсегда.
{FFFFFF}Оскорбление проекта | {FF8129}Блокировка аккаунта на 30 дней.
{FFFFFF}Оскорбление национальности | {FF8129}Блокировка аккаунта на 15 дней.
{FFFFFF}Уход от наказания | {FF8129}Блокировка аккаунта на 10 дней.
{FFFFFF}Продажа/Покупка/Попытка покупки виртов | {FF8129}Блокировка аккаунта навсегда.
{FFFFFF}Обман администрации/игроков | {FF8129}Блокировка аккаунта на 30 дней.
{FFFFFF}Упоминание родных несущий в себе оскорбительный характер | {FF8129}Блокировка аккаунта на 30 дней.
{FFFFFF}Таран на Gelandewagen 6x6|4x4*2 | {FF8129}Блокировка аккаунта на 10 дней.
{FFFFFF}Реклама сторонних ресурсов | {FF8129}Бан от 30 дней до пожизненной блокировки ( в зависимости от рекламы ).
{FFFFFF}Распространение/Использование любых доп. софтов ( читы/программы которые 
{FFFFFF}дают преимущество в игре, AHK(флудеры) для ловли в том числе ) | {FF8129}Блокировка всех аккаунтов навсегда + Блокировка IP адреса.

{FFFFFF}Просьбы, вымогательства чужих паролей | {FF8129}Блокировка аккаунта навсегда.
{FFFFFF}Любая реклама продавцов виртов/репосты с их групп и т.п | {FF8129}Блокировка аккаунта навсегда.
{FFFFFF}Запрещено использование VPN или других подобных программ для смены IP адреса. | {FF8129}Блокировка аккаунта навсегда.
{FFFFFF}Запрещено иметь имущество ( Недвижимость ) на доп. аккаунтах. | {FF8129}Блокировка аккаунта навсегда.
{FFFFFF}Обход системы ( продажа имущества дороже х3, передача 
{FFFFFF}валюты путем продажи/покупки авто и т.д ). | {FF8129}Блокировка аккаунта от 30-ти дней/Конфискация имущества.

{FFFFFF}Запрещено иметь бизнес\семьи\банды\дома\квартиры\гаражи на втором аккаунте. Только на основном. 
{FFFFFF}(Основным аккаунт считается тот, на котором больше уровень) | {FF8129}Блокировка всех аккаунтов навсегда.

{FFFFFF}Запрещается в целях ограничения доступа игроков к игровой информации 
{FFFFFF}путем закрытия своего бизнеса, за для собственной выгоды | {FF8129}Блокировка аккаунта на 30 дней.

{FFFFFF}Запрещена продажа / покупка чего либо у игроков, за реальные деньги | {FF8129}Блокировка всех аккаунтов навсегда.
{FFFFFF}Запрещена покупка/продажа/передача аккаунтов | {FF8129}Блокировка аккаунтов навсегда. ( На других серверах на 30 дней ) 
{FFFFFF}Нанесение урона участникам капта от посторонних лиц | {FF8129}Блокировка аккаунта на 5 дней
	)
	
	showdialog(0, "Общая выдача наказаний", str_dialog_admnakaz3, "Закрыть")
}
return

admnakaz4() {
	
	str_dialog_admnakaz4 =
	
	(
{0000FF}В зависимости от тяжести нарушения

{FFFFFF}Стороне которой передали аккаунт | {FF8129}Блокировка на 30 дней основного аккаунта 
{FFFFFF}( По усмотрению администрации аккаунт могут заблокировать навсегда 
{FFFFFF}или же конфисковать игровое имущество ).

{FFFFFF}Массовый антикапт | {FF8129}Warn лидеру банды по ситуации.
{FFFFFF}Багоюз | {FF8129}Warn/Блокировка аккаунта.
{FFFFFF}NonRP | {FF8129}От деморгана на 60 минут.
{FFFFFF}DM in ZZ со стороны банды | {FF8129}Warn/Блокировка аккаунта на 5 дней. ( до 10 уровня - Warn/Деморган на 120 минут )
{FFFFFF}DM со стороны банды | {FF8129}Деморган на 120 минут/Warn.
{FFFFFF}Запрещено использовать мат/оскорбления в названиях банд/семей ( на смену названия даются сутки. ) | {FF8129}Удаление банды.
{FFFFFF}SK со стороны банды | {FF8129}Warn/Блокировка аккаунта на 5 дней.
	)
	
	showdialog(0, "Общая выдача наказаний", str_dialog_admnakaz4, "Закрыть")
}
return
;//= Окно конец
;//= Окно НАЧАЛО
pravilabiz() {
	
	str_dialog_pravilabiz =
	
	(
{FFFFFF}1.1 Запрещено использовать маски/anim на войне за бизнес после 5-й минуты. | {FF8129}Warn.
{FFFFFF}1.2 Для захвата бизнеса должно быть минимум 5 человек. Максимум 10. | {FF8129}Warn
{FFFFFF}1.3 Запрещено использовать аптечки|/drugs после 5-й минуты. | {FF8129}Warn.
{FFFFFF}1.4 Запрещено возвращаться на место проведения войны за бизнес. | {FF8129}Warn.
{FFFFFF}1.5 Запрещено использовать баги сервера на войне за бизнес. | {FF8129}Warn.
{FFFFFF}нарушителям.
{FFFFFF}Примечание: Минимальное количество(5) для стороны которая захватывает.
{FFFFFF}1.7 Запрещено открывать стрельбу до 5 минуты на таблице. | {FF8129}Warn.
{FFFFFF}1.8 Запрещен Drive By во время войны за бизнес. | {FF8129}Warn.
{FFFFFF}1.9 Запрещено производить помощь от союзных ОПГ/банд на войне за бизнес. | {FF8129}Warn.
{FFFFFF}1.10 Запрещено покидать игру от смерти на войне за бизнес. | {FF8129}Warn.
{FFFFFF}1.11 Запрещено находиться на войне за бизнес имея пинг 200+ | {FF8129}Деморган на 10 минут + Kick.
{FFFFFF}1.12 Запрещено выбегать за квадрат при захвате бизнеса. ( Исключение: Превышен лимит людей на войне за бизнес/это противоречит правилам сервера ) | {FF8129}Warn.
{FFFFFF}1.13 Запрещено находиться на крыше после 5:30 на таблице во-время захвата бизнеса. | {FF8129}Warn.
{FFFFFF}1.14 Сбив онлайна перед каптом. ( Выход с игры за 5 минут до капта/принятие за 
{FFFFFF}5 минут перед каптом/увольнение игрока перед каптом/принятие игрока сразу после начала капта с целью обойти систему каптов. ) | {FF8129}Warn лидеру банды.
{FFFFFF}1.15 Запрещен BH во время стрельбы. | {FF8129}Деморган на 30 минут.
{FFFFFF}1.16 Запрещено создавать помеху рп игрокам, ставить авто преграждая путь/спавн игрокам и нарушая рп-процесс. | {FF8129}Warn основателю банды.
{FFFFFF}1.17 Запрещено убивать игроков, которые не являются помехой. | {FF8129}Warn.
{FFFFFF}1.18 Запрещено участвовать на войне за бизнес с бронёй. | {FF8129}Warn.
{FFFFFF}1.19 Запрещено быть на войне за бизнес с мутом. | {FF8129}Деморган на 60 минут.
{FFFFFF}1.20 Каждый участник обязан записывать видео проведения войны за бизнес.
{FFFFFF}1.21 Запрещено взаимодействовать с транспортным средством после 05:30 на таблице. | {FF8129}Warn.
{FFFFFF}1.22 Заход в квадрат после 5:30 запрещен. | {FF8129}Warn
{FFFFFF}1.23 5+ нарушений со стороны банды за один капт | {FF8129}Warn лидеру банды
{FFFFFF}1.24 Т/С должны быть расположены параллельно друг другу. | {FF8129}Warn за несоблюдение данного правила
{FFFFFF}1.25 Запрещено уходить в AFK во время войны за бизнес. | {FF8129}Kick.
{FFFFFF}1.26 Уход в интерьер после 5:30 на таблице. | {FF8129}Warn.
{FFFFFF}1.27 Целенаправленное убийство администратора, следящего за каптом | {FF8129}Kick
{FFFFFF}1.28 Целенаправленная стрельба до 5-й минуты | {FF8129}Блокировка основного аккаунта от 5-ти дней.
{FFFFFF}1.29 Защищающаяся сторона имеет право зайти ( пешком ) в квадрат после 5:30 в случае если в квадрате нет не одного участника их банды/ОПГ и 0-0 на таблице
{FFFFFF}1.30 При зависании таблицы со счетом, участник капта обязан выйти с квадрата/с игры записав предварительно видео доказательства. | {FF8129}Warn за несоблюдение данного правила.
	)
	
	showdialog(0, "Правила захвата/войны за бизнес", str_dialog_pravilabiz, "Закрыть")
}
return
;//= Окно конец


;//= Окно НАЧАЛО
pravilacapt() {
	
	str_dialog_pravilacapt =
	
	(
{FFFFFF}2.1 Время проведения войны за территорию с 15:00 до 22:15.[МСК]
{FFFFFF}2.2 Запрещено использовать маски/anim на войне за территорию после 5-й минуты. | {FF8129}Warn.
{FFFFFF}2.3 Заход в квадрат после 5:30 запрещен. | {FF8129}Warn
{FFFFFF}2.4 Запрещено использовать аптечки|/drugs после 5-й минуты.| {FF8129}Warn.
{FFFFFF}2.5 Запрещено возвращаться на место проведения войны за территорию.| {FF8129}Warn.

{FFFFFF}Примечание: Проезд в месте квадрата считается за возврат.

{FFFFFF}2.7 Запрещено использовать +С,отводы,сбивы,слайды на войне за территорию.| {FF8129}Warn.
{FFFFFF}2.8 На войне за территорию должно быть от 5 и до 10 человек.| {FF8129}Предупреждение лидеру.

{FFFFFF}Примечание: Минимальное количество(5) для стороны которая захватывает(нападает).

{FFFFFF}2.9 Запрещено открывать стрельбу до 5 минуты на таблице.| {FF8129}Warn.
{FFFFFF}2.10 Запрещен Drive By во время войны за территорию.| {FF8129}Warn.
{FFFFFF}2.11 Запрещено производить помощь от союзных ОПГ/банд на войне за территорию.| {FF8129}Warn.
{FFFFFF}2.12 Запрещено покидать игру от смерти[АнтиФраг] на войне за территорию.| {FF8129}Warn.
{FFFFFF}2.13 Запрещено находиться на войне за территорию имея пинг 200+. | {FF8129}Деморган на 10 минут + Kick.
{FFFFFF}2.15 Начинать войну за территорию разрешено только после PAYDAY.| {FF8129}Warn.
{FFFFFF}2.16 Запрещено начинать войну за территорию куском.| {FF8129}Warn.

{FFFFFF}Исключение: Война за территорию на новом куске районов.

{FFFFFF}2.17 Запрещено взаимодействовать с транспортным средством после 05:30 на таблице. | {FF8129}Форумный выговор|предупреждение лидеру/Warn нарушителям. ИЗМЕНЕНО
{FFFFFF}2.18 Запрещено быть на войне за территорию с мутом. | {FF8129}Деморган на 60 минут.
{FFFFFF}2.19 Количество машин на территории должно быть не менее 4.| {FF8129}Предупреждение лидеру.
{FFFFFF}2.20 Разрешены личные Т/С на войне за территорию аналогичные автопарку ОПГ.
{FFFFFF}2.21 Запрещено находиться на крыше после 5:30 на таблице во-время захвата территории. | {FF8129}Warn.
{FFFFFF}2.22 Квадрат должен прилегать к территории вашей ОПГ.| {FF8129}Предупреждение лидеру.
{FFFFFF}2.23 Каждый участник обязан записывать видео проведения войны за территорию.
{FFFFFF}2.24 Запрещен BH во время стрельбы. | {FF8129}Деморган на 30 минут.
{FFFFFF}2.25 Запрещён выход из квадрата при войне за территорию. | {FF8129}Warn
{FFFFFF}2.26 Т/С должны быть расположены параллельно друг другу. | {FF8129}Warn за игнорирование данного правила.
{FFFFFF}2.27 Запрещено уходить в AFK во время войны за территорию. | {FF8129}Kick.
{FFFFFF}2.28 Уход в интерьер после 5:30 на таблице. | {FF8129}Warn.
{FFFFFF}2.29 Целенаправленное убийство администратора, следящего за каптом | {FF8129}Kick
{FFFFFF}За три и более нарушения за одну войну за территорию лидер наказывается форумным выговором и отдачей территории противнику в случае если у тех нет нарушений.
{FFFFFF}2.30 Целенаправленная стрельба до 5-й минуты | Блокировка аккаунта от 5-ти дней.
{FFFFFF}2.31 Защищающаяся сторона имеет право зайти ( пешком ) в квадрат после 5:30 в случае если в квадрате нет не одного участника их банды/ОПГ и 0-0 на таблице
{FFFFFF}2.32 При зависании таблицы со счетом, участник капта обязан выйти с квадрата/с игры записав предварительно видео доказательства. | {FF8129}Warn за несоблюдение данного правила.
	)
	
	showdialog(0, "Правила проведения войны за территорию", str_dialog_pravilacapt, "Закрыть")
}
return
;//= Окно конец


;//= Окно НАЧАЛО
auto3() {
	
	str_dialog_auto3 =
	
	(
{FF8129}/vec 400 {FFFFFF}Porshe Cayene			{FF8129}/vec 480 {FFFFFF}Audi R8				{FF8129}/vec 543 {FFFFFF}Tesla						
{FF8129}/vec 402 {FFFFFF}Mercedes E63			{FF8129}/vec 489 {FFFFFF}Toyota Cruiser			{FF8129}/vec 558 {FFFFFF}BMW M4			
{FF8129}/vec 405 {FFFFFF}Audi RS6			{FF8129}/vec 490 {FFFFFF}Range Rover			{FF8129}/vec 573 {FFFFFF}Mercedes 6x6
{FF8129}/vec 409 {FFFFFF}Rolls-Royce			{FF8129}/vec 494 {FFFFFF}Dodje SRT			{FF8129}/vec 579 {FFFFFF}Mercedes G65			
{FF8129}/vec 410 {FFFFFF}Merc C63s			{FF8129}/vec 502 {FFFFFF}Rolls-Royce			{FF8129}/vec 587 {FFFFFF}Audi quattro					
{FF8129}/vec 415 {FFFFFF}Lamborgibi Aventador		{FF8129}/vec 503 {FFFFFF}Nissan GTR			{FF8129}/vec 602 {FFFFFF}Jaguar Ftype					
{FF8129}/vec 429 {FFFFFF}Merc Maybach S650		{FF8129}/vec 505 {FFFFFF}bentley bentayga		{FF8129}/vec 604 {FFFFFF}Porshe Panamera Turbo				
{FF8129}/vec 436 {FFFFFF}KIA Stinger			{FF8129}/vec 506 {FFFFFF}Porshe 911			{FF8129}/vec 605 {FFFFFF}Lamborgini huracan				
{FF8129}/vec 451 {FFFFFF}Ferrari F12			{FF8129}/vec 533 {FFFFFF}Porshe 718			{FF8129}/vec 793 {FFFFFF}Audi Q7 V12 TDI				
{FF8129}/vec 466 {FFFFFF}BMW 540l			{FF8129}/vec 541 {FFFFFF}ferrari laferrari			{FF8129}/vec 794 {FFFFFF}BMW M2	
{FF8129}/vec 795 {FFFFFF}Mercedes 4x4			{FF8129}/vec 796 {FFFFFF}Mercedes Class			{FF8129}/vec 797 {FFFFFF}Ford GT
{FF8129}/vec 798 {FFFFFF}Mercedes S65			{FF8129}/vec 907 {FFFFFF}BMW X5			{FF8129}/vec 965 {FFFFFF}Mercedes S650
{FF8129}/vec 999 {FFFFFF}Lamborgini Urus		{FF8129}/vec 1326 {FFFFFF}Mercedes GLE 63		{FF8129}/vec 15071 {FFFFFF}Lexus LX 570
{FF8129}/vec 15073 {FFFFFF}BMW 740 F02			{FF8129}/vec 15075 {FFFFFF}Jeep				{FF8129}/vec 15076 {FFFFFF}ESCALADE
{FF8129}/vec 15082 {FFFFFF}Mercedes AMG		{FF8129}/vec 15085 {FFFFFF}Bugatti chiron		{FF8129}/vec 15089 {FFFFFF}Audi RS 7
{FF8129}/vec 15092 {FFFFFF}Volvo XC90			{FF8129}/vec 15094 {FFFFFF}BMW X6M			
	)
	
	showdialog(0, "Высокий класс", str_dialog_auto3, "Закрыть")
}
return
;//= Окно конец
;//= Окно НАЧАЛО
auto2() {
	
	str_dialog_auto2 =
	
	(
{FF8129}/vec 411 {FFFFFF}Lancer Evo MR		{FF8129}/vec 419 {FFFFFF}Z ORC			{FF8129}/vec 445 {FFFFFF}Shkoda
{FF8129}/vec 458 {FFFFFF}Audi			{FF8129}/vec 459 {FFFFFF}Mercedes Vito		{FF8129}/vec 475 {FFFFFF}BMW X5
{FF8129}/vec 477 {FFFFFF}Mazda RX7		{FF8129}/vec 479 {FFFFFF}Reno Logan		{FF8129}/vec 491 {FFFFFF}Honda Civic
{FF8129}/vec 495 {FFFFFF}Ford Raptor		{FF8129}/vec 507 {FFFFFF}BMW E34		{FF8129}/vec 508 {FFFFFF}Ford Raptor
{FF8129}/vec 516 {FFFFFF}Ford Focus		{FF8129}/vec 534 {FFFFFF}BMW E30		{FF8129}/vec 540 {FFFFFF}Mercedes e55
{FF8129}/vec 550 {FFFFFF}Приора			{FF8129}/vec 551 {FFFFFF}BMW E39		{FF8129}/vec 554 {FFFFFF}Uaz Patriot
{FF8129}/vec 559 {FFFFFF}Tayota Supra		{FF8129}/vec 560 {FFFFFF}Subaru WRX STI	{FF8129}/vec 562 {FFFFFF}Nissan Skyline
{FF8129}/vec 585 {FFFFFF}Mercedes S600		{FF8129}/vec 589 {FFFFFF}Volkswagen R		{FF8129}/vec 612 {FFFFFF}BMW E60
{FF8129}/vec 613 {FFFFFF}Niva Urban 4x4		{FF8129}/vec 614 {FFFFFF}BMW X6M		{FF8129}/vec 699 {FFFFFF}Volkswagen Beetle
{FF8129}/vec 908 {FFFFFF}BMW X5M		{FF8129}/vec 909 {FFFFFF}Volvo XC 90		{FF8129}/vec 15065 {FFFFFF}Tayota Chaser
{FF8129}/vec 15066 {FFFFFF}Volkswagen HR50	{FF8129}/vec 15067 {FFFFFF}BMW 740I		{FF8129}/vec 15068 {FFFFFF}Mark 2
{FF8129}/vec 15069 {FFFFFF}Tayota Camry		{FF8129}/vec 15072 {FFFFFF}Lexus IS300		{FF8129}/vec 15077 {FFFFFF}Honda Accord
{FF8129}/vec 15081 {FFFFFF}Volkswagen R		{FF8129}/vec 15086 {FFFFFF}Lexus IS F		{FF8129}/vec 15087 {FFFFFF}Mazda 3
{FF8129}/vec 15088 {FFFFFF}Mazda MX-5		{FF8129}/vec 15090 {FFFFFF}Nissan Silvia		{FF8129}/vec 15093 {FFFFFF}Mercedes E500
	)
	
	showdialog(0, "Средний класс", str_dialog_auto2, "Закрыть")
}
return
;//= Окно конец
;//= Окно НАЧАЛО
auto1() {
	
	str_dialog_auto1 =
	
	(
{FF8129}/vec 401 {FFFFFF}ИЖ 2715		{FF8129}/vec 404 {FFFFFF}Volvo 850R	{FF8129}/vec 412 {FFFFFF}Mercedes W123
{FF8129}/vec 421 {FFFFFF}Peugeot 406		{FF8129}/vec 422 {FFFFFF}Jepp 4.0	{FF8129}/vec 439 {FFFFFF}ВАЗ 2101
{FF8129}/vec 467 {FFFFFF}ВАЗ 2107		{FF8129}/vec 478 {FFFFFF}ИЖ 27151	{FF8129}/vec 482 {FFFFFF}Газель
{FF8129}/vec 492 {FFFFFF}ВАЗ 2109		{FF8129}/vec 496 {FFFFFF}Z Opel		{FF8129}/vec 500 {FFFFFF}Uaz Hunter
{FF8129}/vec 518 {FFFFFF}ЕРАЗ-762		{FF8129}/vec 526 {FFFFFF}Ford Siera	{FF8129}/vec 527 {FFFFFF}Golf Gti
{FF8129}/vec 536 {FFFFFF}Volvo Turbo		{FF8129}/vec 542 {FFFFFF}Луазэ		{FF8129}/vec 546 {FFFFFF}ИЖ 2125 Комби
{FF8129}/vec 547 {FFFFFF}Audi 80			{FF8129}/vec 549 {FFFFFF}ОКА		{FF8129}/vec 555 {FFFFFF}ЗАЗ 968М
{FF8129}/vec 561 {FFFFFF}ВАЗ 2115		{FF8129}/vec 565 {FFFFFF}ВАЗ 2108	{FF8129}/vec 566 {FFFFFF}Lanos
{FF8129}/vec 567 {FFFFFF}ВАЗ 2106		{FF8129}/vec 576 {FFFFFF}АЗЛК-408	{FF8129}/vec 600 {FFFFFF}ИЖ 2717
{FF8129}/vec 799 {FFFFFF}ГАЗ 31105 ВОЛГА	{FF8129}/vec 15070 {FFFFFF}Буханка	{FF8129}/vec 15074 {FFFFFF}ВАЗ 2114
{FF8129}/vec 15078 {FFFFFF}ВАЗ 2110		{FF8129}/vec 15079 {FFFFFF}ВАЗ 2104	{FF8129}/vec 15080 {FFFFFF}ВАЗ 2107
{FF8129}/vec 15083 {FFFFFF}ГАЗ 66		{FF8129}/vec 15084 {FFFFFF}Alfa Romeo 155
	)
	
	showdialog(0, "Низкий класс", str_dialog_auto1, "Закрыть")
}
return
;//= Окно конец
;//= Окно НАЧАЛО
auto0() {
	
	str_dialog_auto0 =
	
	(
{FF8129}/vec 461 {FFFFFF}Honda CB 750
{FF8129}/vec 462 {FFFFFF}SCOOTER
{FF8129}/vec 463 {FFFFFF}Harley Chopper
{FF8129}/vec 468 {FFFFFF}MotoCross
{FF8129}/vec 471 {FFFFFF}Snowmobile
{FF8129}/vec 481 {FFFFFF}BMX
{FF8129}/vec 510 {FFFFFF}BTBIKE
{FF8129}/vec 521 {FFFFFF}ИЖ
{FF8129}/vec 522 {FFFFFF}Ducati Desmosed
{FF8129}/vec 581 {FFFFFF}Suzuki Hayabusa
{FF8129}/vec 586 {FFFFFF}Harley Fat Boy
	)
	
	showdialog(0, "Мото/Вело класс", str_dialog_auto0, "Закрыть")
}
return
;//= Окно конец
;//= Окно НАЧАЛО
auto4() {
	
	str_dialog_auto4 =
	
	(
{FF8129}/vec 430 {FFFFFF}Лодка Police
{FF8129}/vec 446 {FFFFFF}Лодка
{FF8129}/vec 452 {FFFFFF}Лодка
{FF8129}/vec 453 {FFFFFF}Лодка
{FF8129}/vec 454 {FFFFFF}Лодка
{FF8129}/vec 472 {FFFFFF}Лодка Police
{FF8129}/vec 473 {FFFFFF}Лодка
{FF8129}/vec 493 {FFFFFF}Лодка
{FF8129}/vec 595 {FFFFFF}Лодка
{FF8129}/vec 484 {FFFFFF}Корабль
	)
	
	showdialog(0, "Водный класс", str_dialog_auto4, "Закрыть")
}
return
;//= Окно конец
;//= Окно НАЧАЛО
auto5() {
	
	str_dialog_auto5 =
	
	(
{FF8129}/vec 417 {FFFFFF}Вертолет
{FF8129}/vec 425 {FFFFFF}Военый верт
{FF8129}/vec 447 {FFFFFF}Водный верт
{FF8129}/vec 460 {FFFFFF}Самолёт AH-2B
{FF8129}/vec 469 {FFFFFF}Вертолет R22
{FF8129}/vec 476 {FFFFFF}Самолёт
{FF8129}/vec 487 {FFFFFF}Вертолет R44
{FF8129}/vec 488 {FFFFFF}Вертолет SAN
{FF8129}/vec 511 {FFFFFF}Самолет
{FF8129}/vec 512 {FFFFFF}Самолет
{FF8129}/vec 513 {FFFFFF}Самолет
{FF8129}/vec 497 {FFFFFF}Вертолет Полиции
{FF8129}/vec 519 {FFFFFF}Самолет аэрофлот
{FF8129}/vec 520 {FFFFFF}Самолет военный
{FF8129}/vec 548 {FFFFFF}Вертолет военный
{FF8129}/vec 553 {FFFFFF}Cамолет СССР-46532
{FF8129}/vec 563 {FFFFFF}Вертолет FD 371
{FF8129}/vec 577 {FFFFFF}Cамолет (для РП)
{FF8129}/vec 592 {FFFFFF}Cамолет
{FF8129}/vec 593 {FFFFFF}Самолет СССР-03755
	)
	
	showdialog(0, "Воздушный класс", str_dialog_auto5, "Закрыть")
}
return
;//= Окно конец
;//= Окно НАЧАЛО
auto6() {
	
	str_dialog_auto6 =
	
	(
{FF8129}/vec 403 {FFFFFF}Грузовик Scania		{FF8129}/vec 406 {FFFFFF}ЗИЛ				{FF8129}/vec 407 {FFFFFF}URAL МЧС
{FF8129}/vec 408 {FFFFFF}ЗИЛ Мусорка			{FF8129}/vec 413 {FFFFFF}Автобуса ГАЗ			{FF8129}/vec 414 {FFFFFF}Лиаз
{FF8129}/vec 416 {FFFFFF}Газель МЗ			{FF8129}/vec 418 {FFFFFF}Автобус Radmir			{FF8129}/vec 420 {FFFFFF}FORD Такси
{FF8129}/vec 423 {FFFFFF}Машина мороженное		{FF8129}/vec 424 {FFFFFF}CМЗ				{FF8129}/vec 426 {FFFFFF}Чайка
{FF8129}/vec 427 {FFFFFF}ФСИН перевозка		{FF8129}/vec 428 {FFFFFF}Сбер				{FF8129}/vec 431 {FFFFFF}Автобус Radmir2
{FF8129}/vec 432 {FFFFFF}Танк 				{FF8129}/vec 433 {FFFFFF}Урал военный			{FF8129}/vec 434 {FFFFFF}Хот рот
{FF8129}/vec 435 {FFFFFF}Для перевозки 			{FF8129}/vec 437 {FFFFFF}Автобус Ikarus 260		{FF8129}/vec 438 {FFFFFF}Reno Такси
{FF8129}/vec 440 {FFFFFF}Грузовик банд			{FF8129}/vec 442 {FFFFFF}Немецкая машина		{FF8129}/vec 443 {FFFFFF}Машина с трамплином
{FF8129}/vec 444 {FFFFFF}Большая машина на колесах 	{FF8129}/vec 448 {FFFFFF}Мопед Пицца			{FF8129}/vec 450 {FFFFFF}Для перевозки2
{FF8129}/vec 455 {FFFFFF}Машина Вода			{FF8129}/vec 456 {FFFFFF}Газель				{FF8129}/vec 457 {FFFFFF}Для гольфа
{FF8129}/vec 470 {FFFFFF}Тигр Военный			{FF8129}/vec 474 {FFFFFF}ВАИ				{FF8129}/vec 483 {FFFFFF}ПАЗ
{FF8129}/vec 485 {FFFFFF}Машина аэрофлот		{FF8129}/vec 486 {FFFFFF}Трактор			{FF8129}/vec 498 {FFFFFF}Автобус Лиаз
{FF8129}/vec 499 {FFFFFF}Газ Хлеб			{FF8129}/vec 504 {FFFFFF}496 Sport			{FF8129}/vec 509 {FFFFFF}Велосипед
{FF8129}/vec 514 {FFFFFF}Камаз				{FF8129}/vec 515 {FFFFFF}Камаз Reno			{FF8129}/vec 517 {FFFFFF}Raf Такси
{FF8129}/vec 523 {FFFFFF}ДПС Мотоцикл 			{FF8129}/vec 524 {FFFFFF}Dude месилка			{FF8129}/vec 525 {FFFFFF}Газ механиков
{FF8129}/vec 528 {FFFFFF}Patriot Полиция		{FF8129}/vec 529 {FFFFFF}Mercedes 560 SEL		{FF8129}/vec 530 {FFFFFF}Машинка для ящиков
{FF8129}/vec 531 {FFFFFF}Трактор			{FF8129}/vec 532 {FFFFFF}Кобмайн			{FF8129}/vec 535 {FFFFFF}Subaru STI Impreza
{FF8129}/vec 539 {FFFFFF}Неизвестно			{FF8129}/vec 544 {FFFFFF}МЧС 				{FF8129}/vec 545 {FFFFFF}Москвич
{FF8129}/vec 552 {FFFFFF}Газель ремотная		{FF8129}/vec 556 {FFFFFF}Большая машина на колесах	{FF8129}/vec 557 {FFFFFF}Большая машина на колесах
{FF8129}/vec 568 {FFFFFF}Гоночная			{FF8129}/vec 571 {FFFFFF}Картинг			{FF8129}/vec 572 {FFFFFF}Машина для уборки
{FF8129}/vec 574 {FFFFFF}Sanitary Sandreas		{FF8129}/vec 575 {FFFFFF}Москвич			{FF8129}/vec 578 {FFFFFF}Урал военный
{FF8129}/vec 580 {FFFFFF}Лайка				{FF8129}/vec 582 {FFFFFF}ТРК				{FF8129}/vec 583 {FFFFFF}Машина с аэропорт
{FF8129}/vec 584 {FFFFFF}цистерна для топлива		{FF8129}/vec 588 {FFFFFF}Автобус минутка		{FF8129}/vec 590 {FFFFFF}Вагон
{FF8129}/vec 591 {FFFFFF}Прицеп				{FF8129}/vec 596 {FFFFFF}ВАЗ ДПС 2107 			{FF8129}/vec 597 {FFFFFF}Reno ДПС
{FF8129}/vec 598 {FFFFFF}BMW ДПС			{FF8129}/vec 599 {FFFFFF}СВАО Милиция			{FF8129}/vec 601 {FFFFFF}БТР
{FF8129}/vec 603 {FFFFFF}Dodge Charger			{FF8129}/vec 606 {FFFFFF}Лодка прицеп 			{FF8129}/vec 607 {FFFFFF}Прицеп
{FF8129}/vec 608 {FFFFFF}Лестница			{FF8129}/vec 609 {FFFFFF}Грузовая 			{FF8129}/vec 611 {FFFFFF}Прицеп
{FF8129}/vec 15091 {FFFFFF}USA Машина
	)
	
	showdialog(0, "Доп класс", str_dialog_auto6, "Закрыть")
}
return
;//= Окно конец

;//= Окно НАЧАЛО
gunid() {
	
	str_dialog_gunid =
	
	(
{FF8129}1 {FFFFFF}Кастет			{FF8129}2 {FFFFFF}Клюшка для гольфа		{FF8129}3 {FFFFFF}Полицейская дубинка
{FF8129}4 {FFFFFF}Нож				{FF8129}5 {FFFFFF}Бейсбольная бита		{FF8129}6 {FFFFFF}Лопата
{FF8129}7 {FFFFFF}Кий				{FF8129}8 {FFFFFF}Катана			{FF8129}9 {FFFFFF}Бензопила
{FF8129}10 {FFFFFF}Двухсторонний дилдо	{FF8129}11 {FFFFFF}Дилдо			{FF8129}12 {FFFFFF}Вибратор
{FF8129}13 {FFFFFF}Серебряный вибратор	{FF8129}14 {FFFFFF}Букет цветов			{FF8129}15 {FFFFFF}Трость
{FF8129}16 {FFFFFF}Граната			{FF8129}17 {FFFFFF}Слезоточивый газ		{FF8129}18 {FFFFFF}Коктейль Молотова
{FF8129}22 {FFFFFF}Пистолет 9мм		{FF8129}23 {FFFFFF}Пистолет 9мм с глушителем	{FF8129}24 {FFFFFF}Пистолет Дезерт Игл
{FF8129}25 {FFFFFF}Обычный дробовик		{FF8129}26 {FFFFFF}Обрез			{FF8129}27 {FFFFFF}Скорострельный дробовик
{FF8129}28 {FFFFFF}Узи				{FF8129}29 {FFFFFF}MP5				{FF8129}30 {FFFFFF}Автомат Калашникова
{FF8129}31 {FFFFFF}Винтовка M4			{FF8129}32 {FFFFFF}Tec-9			{FF8129}33 {FFFFFF}Охотничье ружье
{FF8129}34 {FFFFFF}Снайперская винтовка	{FF8129}35 {FFFFFF}РПГ				{FF8129}36 {FFFFFF}Самонаводящиеся ракеты HS
{FF8129}37 {FFFFFF}Огнемет			{FF8129}38 {FFFFFF}Миниган			{FF8129}39 {FFFFFF}Сумка с тротилом
{FF8129}40 {FFFFFF}Детонатор к сумке		{FF8129}41 {FFFFFF}Баллончик с краской		{FF8129}42 {FFFFFF}Огнетушитель
{FF8129}43 {FFFFFF}Фотоаппарат			{FF8129}44 {FFFFFF}Прибор ночного видения	{FF8129}45 {FFFFFF}Тепловизор
{FF8129}46 {FFFFFF}Парашют
	)
	
	showdialog(0, "ID Оружий", str_dialog_gunid, "Закрыть")
}
return
;//= Окно конец

;//= Окно НАЧАЛО
gosinfo() {
	
	str_dialog_gosinfo =
	
	(
{FF8129}Запрещено: {FFFFFF}Находиться в казино/бильярде в форме | Jail 120 мин.
{FF8129}Запрещено: {FFFFFF}Охране ездить по городу без Руководства | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}Водителю ездить по городу без Руководства | Jail 60 мин
{FF8129}Запрещено: {FFFFFF}Губернатору и Заместителю ездить без охраны | Jail 120 мин.
{FF8129}Запрещено: {FFFFFF}Работать на шахте\лесопилке и т.д в рабочее время | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}AFK без ESC | Warn ( До 3 ранга включительно Jail 120 мин. )
{FF8129}Запрещено: {FFFFFF}Использовать информацию о слетах имущества для собственной выгоды | Warn 
{FF8129}Запрещено: {FFFFFF}Пользоваться полномочиями адвоката/лицензера без наличия формы | Warn
{800000}Примечание: Адвокаты не имеют права требовать доп. плату за свои услуги или же вынуждать кого либо платить дополнительно.

{00BFFF}Примечание: администратор ОБЯЗАН предупредить игрока и узнать причину прогула.
Каждый сотрудник ДПС/ППС/ФСИН обязан записывать видео нарушения игроков перед выдачей звезд/повышении срока/убийством нарушителей, 
в случае подачи жалобы на сотрудника у него будет 3 дня на предоставление доказательств в определенной теме, если сотрудник гос. 
структуры проигнорирует, его накажут варном.

{FF0000}Прогул в рабочее время без напарника | Деморган на 60-120 минут. 
{FF0000}Исключение: Мотобатальон в патруле, адвокаты, лицензеры, Эвакуаторы ДПС.

{00BFFF}Примечание: Запрещено находится в форме:
- Казино
- Бильярд
- Аукцион
- Б/У рынок
- Начальные работы
- Риэлторское агентство 
- Порт ( Контейнеры )
	)
	
	
	showdialog(2, "Правительство | Правила для гос. структур", str_dialog_gosinfo, "Закрыть")
}
return


;//= Окно конец
;//= Окно НАЧАЛО
gosinfo1() {
	
	str_dialog_gosinfo1 =
	
	(
{FF8129}Запрещено: {FFFFFF}Находиться в казино/бильярде в форме | Jail 120 мин.
{FF8129}Запрещено: {FFFFFF}Работать на шахте\лесопилке и т.д в рабочее время | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}AFK без ESC | Warn ( До 3 ранга включительно Jail 120 мин. )
{FF8129}Запрещено: {FFFFFF}Проводить арест/выдачу звезд без наличия формы | Warn.
{FF8129}Запрещено: {FFFFFF}Выдавать звезды/проводить обыск в Деморгане | Warn.
{FF8129}Запрещено: {FFFFFF}Убийство без причины, снятие/выдача розысков, штрафов без причины,
NonRP /cuff, задержание в одиночку, использование мигалок в личных целях, убийство без необходимости и т.п ) | Warn.

{00BFFF}Примечание: администратор ОБЯЗАН предупредить игрока и узнать причину прогула.
Каждый сотрудник ДПС/ППС/ФСИН обязан записывать видео нарушения игроков перед выдачей звезд/повышении срока/убийством нарушителей,
в случае подачи жалобы на сотрудника у него будет 3 дня на предоставление доказательств в определенной теме, если сотрудник гос.
структуры проигнорирует, его накажут варном.

{FF0000}Прогул в рабочее время без напарника | Деморган на 60-120 минут.
{FF0000}Исключение: Мотобатальон в патруле, адвокаты, лицензеры, Эвакуаторы ДПС.

{00BFFF}Примечание: Запрещено находится в форме:
- Казино
- Бильярд
- Аукцион
- Б/У рынок
- Начальные работы
- Риэлторское агентство
- Порт ( Контейнеры )
	)
	
	
	showdialog(0, "МВД | Правила для гос. структур", str_dialog_gosinfo1, "Закрыть")
}
return


;//= Окно конец
;//= Окно НАЧАЛО
gosinfo2() {
	
	str_dialog_gosinfo2 =
	
	(
{FF8129}Запрещено: {FFFFFF}Находиться в казино/бильярде в форме| Jail 120 мин
{FF8129}Запрещено: {FFFFFF}Работать на шахте\лесопилке и т.д в рабочее время | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}Брать бронежилет во время боя/перестрелки | Warn 
{FF8129}Запрещено: {FFFFFF}Ехать 1 в машине за БП I /jail 60
{FF8129}Запрещено: {FFFFFF}AFK без ESC | Warn ( До 3 ранга включительно Jail 120 мин. )

Правила поездки за контрабандой
Для взятия контрабанды необходимо минимум 4 человека. | {FF8129}Warn.
С сумкой запрещено прыгать, быстро бегать,ехать в машине с сумкой. | {FF8129}Деморган на 60 минут.
Для взятия контрабанды RP отыгровка обязательна для каждого действия! | {FF8129}Деморган на 120 минут
	
{800000}Примечание: Для поездки за боеприпасами должна быть колонна минимум с 2-х военных автомобилей, включая сопровождение ВАИ. 
За нарушение данного правила вы будете наказаны Деморганом на 60 минут. ( исключение: поездка за боеприпасами на вертолете )

{00BFFF}Примечание: администратор ОБЯЗАН предупредить игрока и узнать причину прогула.
Каждый сотрудник ДПС/ППС/ФСИН обязан записывать видео нарушения игроков перед выдачей звезд/повышении срока/убийством нарушителей, 
в случае подачи жалобы на сотрудника у него будет 3 дня на предоставление доказательств в определенной теме, если сотрудник гос. 
структуры проигнорирует, его накажут варном.

{FF0000}Прогул в рабочее время без напарника | Деморган на 60-120 минут. 
{FF0000}Исключение: Мотобатальон в патруле, адвокаты, лицензеры, Эвакуаторы ДПС.

{00BFFF}Примечание: Запрещено находится в форме:
- Казино
- Бильярд
- Аукцион
- Б/У рынок
- Начальные работы
- Риэлторское агентство 
- Порт ( Контейнеры ) 
	)
	
	
	showdialog(0, "Министерство Обороны | Правила для гос. структур", str_dialog_gosinfo2, "Закрыть")
}
return


;//= Окно конец
;//= Окно НАЧАЛО
gosinfo3() {
	
	str_dialog_gosinfo3 =
	
	(
{FF8129}Запрещено: {FFFFFF}Находиться в казино/бильярде в форме | Jail 120 мин.
{FF8129}Запрещено: {FFFFFF}Работать на шахте\лесопилке и т.д в рабочее время | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}Отказывать в лечение больного из-за личной неприязни | Warn
{FF8129}Запрещено: {FFFFFF}AFK без ESC | Warn ( До 3 ранга включительно Jail 120 мин. )
{FF8129}Запрещено: {FFFFFF}Лечить без RP отыгровки | Warn.

{00BFFF}Примечание: администратор ОБЯЗАН предупредить игрока и узнать причину прогула.
Каждый сотрудник ДПС/ППС/ФСИН обязан записывать видео нарушения игроков перед выдачей звезд/повышении срока/убийством нарушителей, 
в случае подачи жалобы на сотрудника у него будет 3 дня на предоставление доказательств в определенной теме, если сотрудник гос. 
структуры проигнорирует, его накажут варном.

{FF0000}Прогул в рабочее время без напарника | Деморган на 60-120 минут. 
{FF0000}Исключение: Мотобатальон в патруле, адвокаты, лицензеры, Эвакуаторы ДПС.

{00BFFF}Примечание: Запрещено находится в форме:
- Казино
- Бильярд
- Аукцион
- Б/У рынок
- Начальные работы
- Риэлторское агентство 
- Порт ( Контейнеры ) 
	)
	
	
	showdialog(0, "Министерство Здравоохранения | Правила для гос. структур", str_dialog_gosinfo3, "Закрыть")
}
return


;//= Окно конец
;//= Окно НАЧАЛО
gosinfo4() {
	
	str_dialog_gosinfo4 =
	
	(
{FF8129}Запрещено: {FFFFFF}Находиться в казино/бильярде в форме | Jail 120 min
{FF8129}Запрещено: {FFFFFF}Работать на шахте\лесопилке и т.д в рабочее время | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}Отправлять не отредактированные объявления | mute 30 мин.
{FF8129}Запрещено: {FFFFFF}Нести бред в эфир | Warn\Ban\Mute
{FF8129}Запрещено: {FFFFFF}AFK без ESC | Warn ( До 3 ранга включительно Jail 120 мин. )
{FF8129}Запрещено: {FFFFFF}Проверять/редактировать объявления находясь вне здания организации/специального Т/С | Jail 120 min

{00BFFF}Примечание: администратор ОБЯЗАН предупредить игрока и узнать причину прогула.
Каждый сотрудник ДПС/ППС/ФСИН обязан записывать видео нарушения игроков перед выдачей звезд/повышении срока/убийством нарушителей, 
в случае подачи жалобы на сотрудника у него будет 3 дня на предоставление доказательств в определенной теме, если сотрудник гос. 
структуры проигнорирует, его накажут варном.

{FF0000}Прогул в рабочее время без напарника | Деморган на 60-120 минут. 
{FF0000}Исключение: Мотобатальон в патруле, адвокаты, лицензеры, Эвакуаторы ДПС.

{00BFFF}Примечание: Запрещено находится в форме:
- Казино
- Бильярд
- Аукцион
- Б/У рынок
- Начальные работы
- Риэлторское агентство 
- Порт ( Контейнеры ) 
	)
	
	
	showdialog(0, "ТРК | Правила для гос. структур", str_dialog_gosinfo4, "Закрыть")
}
return


;//= Окно конец
;//= Окно НАЧАЛО
gosinfo5() {
	
	str_dialog_gosinfo5 =
	
	(
{FF8129}Запрещено: {FFFFFF}Находиться в казино/бильярде в форме | Jail 120 min
{FF8129}Запрещено: {FFFFFF}Работать на шахте\лесопилке и тд. в рабочее время | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}Отправляться в одиночку на пожары/поливать игроков с пожарного автомобиля | Jail 120 мин.
{FF8129}Запрещено: {FFFFFF}AFK без ESC | Warn ( До 3 ранга включительно Jail 120 мин. )

{00BFFF}Примечание: администратор ОБЯЗАН предупредить игрока и узнать причину прогула.
Каждый сотрудник ДПС/ППС/ФСИН обязан записывать видео нарушения игроков перед выдачей звезд/повышении срока/убийством нарушителей, 
в случае подачи жалобы на сотрудника у него будет 3 дня на предоставление доказательств в определенной теме, если сотрудник гос. 
структуры проигнорирует, его накажут варном.

{FF0000}Прогул в рабочее время без напарника | Деморган на 60-120 минут. 
{FF0000}Исключение: Мотобатальон в патруле, адвокаты, лицензеры, Эвакуаторы ДПС.

{00BFFF}Примечание: Запрещено находится в форме:
- Казино
- Бильярд
- Аукцион
- Б/У рынок
- Начальные работы
- Риэлторское агентство 
- Порт ( Контейнеры ) 
	)
	
	
	showdialog(0, "Министерство Чрезвычайных ситуаций | Правила для гос. структур", str_dialog_gosinfo5, "Закрыть")
}
return


;//= Окно конец
;//= Окно НАЧАЛО
gosinfo6() {
	
	str_dialog_gosinfo6 =
	
	(
{FF8129}Запрещено: {FFFFFF}Находиться в казино/бильярде в форме | Jail 120 min
{FF8129}Запрещено: {FFFFFF}Работать на шахте\лесопилке и тд. в рабочее время | Jail 60 мин.
{FF8129}Запрещено: {FFFFFF}Отправляться за заключенными в одиночку | Jail 120 мин.
{FF8129}Запрещено: {FFFFFF}AFK без ESC | Warn ( Для 1 ранга Jail 120 мин. )

{00BFFF}Примечание: администратор ОБЯЗАН предупредить игрока и узнать причину прогула.
Каждый сотрудник ДПС/ППС/ФСИН обязан записывать видео нарушения игроков перед выдачей звезд/повышении срока/убийством нарушителей, 
в случае подачи жалобы на сотрудника у него будет 3 дня на предоставление доказательств в определенной теме, если сотрудник гос. 
структуры проигнорирует, его накажут варном.

{FF0000}Прогул в рабочее время без напарника | Деморган на 60-120 минут. 
{FF0000}Исключение: Мотобатальон в патруле, адвокаты, лицензеры, Эвакуаторы ДПС.

{00BFFF}Примечание: Запрещено находится в форме:
- Казино
- Бильярд
- Аукцион
- Б/У рынок
- Начальные работы
- Риэлторское агентство 
- Порт ( Контейнеры ) 
	)
	
	
	showdialog(0, "ФСИН | Правила для гос. структур", str_dialog_gosinfo6, "Закрыть")
}
return


;//= Окно конец


;//= Функции команд


atinfo() {
    addChatMessage("[SKRIPT] Информация,на экране")
	IniRead, nick, %config%, config, nick, none
	IniRead, all, %config%, config, all, 0
	IniRead, normaans, %config%, config, normaans, 300

	FormatTime, time, T12, Time
	FormatTime, date,, LongDate

	cleardouble()

	oAns := normaans-totalans

	xnormaans:=totalans/300
	regexmatch(xnormaans, "(.*)\.", out_x)
	x_plus_one := out_x1+1
	x_two := 400*x_plus_one
	x2normaans:=x_two-totalans


	if (all == 1)
		statsnak =
(

{FFD933}`t`tИнформация по наказаниям`n`n
{ffffff}Кол - во выполненных {FF8129}/pm:`t`t`t{05A9FF}%totalans%

{ffffff}Кол - во выполненных {FF8129}/z:`t`t`t{05A9FF}%totalz%

{ffffff}Кол - во выполненных {FF8129}/jail:`t`t`t{05A9FF}%totaljail%

{ffffff}Кол - во выполненных {FF8129}/kick:`t`t`t{05A9FF}%totalkick%

{ffffff}Кол - во выполненных {FF8129}/mute:`t`t`t{05A9FF}%totalmute%

{ffffff}Кол - во выполненных {FF8129}/rmute:`t`t`t{05A9FF}%totalrmute%

{ffffff}Кол - во выполненных {FF8129}/warn:`t`t`t{05A9FF}%totalwarn%

{ffffff}Кол - во выполненных {FF8129}/ban:`t`t`t{05A9FF}%totalban% `n`n
{008000}`t`t`t RADMIR RP 04`n`n
)

	if (totalans < 300)
		statsnak =
(

{FFD933}`t`tИнформация по наказаниям`n`n

{ffffff}Кол - во выполненных {FF8129}/pm :`t`t`t{05A9FF}%totalans%

{ffffff}Кол - во выполненных {FF8129}/z:`t`t`t{05A9FF}%totalz%

{ffffff}Кол - во выполненных {FF8129}/jail:`t`t`t{05A9FF}%totaljail%

{ffffff}Кол - во выполненных {FF8129}/kick:`t`t`t{05A9FF}%totalkick%

{ffffff}Кол - во выполненных {FF8129}/mute:`t`t`t{05A9FF}%totalmute%

{ffffff}Кол - во выполненных {FF8129}/rmute:`t`t`t{05A9FF}%totalrmute%

{ffffff}Кол - во выполненных {FF8129}/warn:`t`t`t{05A9FF}%totalwarn%

{ffffff}Кол - во выполненных {FF8129}/ban:`t`t`t{05A9FF}%totalban% `n`n
{008000}`t`t`t RADMIR RP 04`n`n
)
	if (all == 0)
		statsnak =

	ShowDialog(0, "{FF0000}Cтатистика {FFFFE0}| Администратора `t`t`t`t`t{05A9FF}"nick "", "" statsnak "{FFFFFF}Время:`t`t`t`t`t`t{05A9FF}" time "{FFFFFF}`nТекущая дата:`t`t`t`t`t{05A9FF}" date "", "Закрыть")
}
return

clearst() {
	FileGetTime, time, other\done, C
	
	regexmatch(time, "(.{1,4})(.{1,2})(.{1,2})", out_time)
	
	time_str = %out_time3%.%out_time2%.%out_time1%
	FileRemoveDir, other\done, 1
	FileCreateDir, other\done
	addchatmessage("{ff87cc}• Информация: {ffffff}Статистика обнулена за " time_str "")
	reload
}

; ===

start() {
	Sleep, 200
	IfWinActive, GTA:SA:MP
	{
		IniRead, reload, %config%, config, reload
		if (reload) { 
			IniWrite, 0, %config%, config, reload
			SetTimer, helper_use, off
			SetTimer, helperz, off
			SetTimer, helper_find, off
		}
		restorelog()
		
		RegRead, NickName, HKEY_CURRENT_USER, Software\SAMP, PlayerName
		IniWrite, %NickName%, %config%, config, nick

		IniRead, all, %config%, config, all, 0
		SetTimer, chat, % (all ? 50 : "off")

		SetTimer, start, off
	}
}
return

chat() {
	IniRead, nick, %config%, config, nick, none, none
	FormatTime, TimeStringss,, LongDate
	FormatTime, TimeStringsss, T12, Time
	fileRead, ChatLogg, %chatlog%
	
	if (RegExMatch(ChatLogg, "Вы ответили на запрос №([0-9]+)", zout)) {
		FileAppend, [%TimeStringss% | %TimeStringsss%] : Вы ответили на запрос №%zout1%`n, %A_ScriptDir%\other\done\z.txt 
		restorelog()
	}
	
	if (RegExMatch(ChatLogg, "Администратор " nick "\Q[\E(.*)\Q]\E для (.*)\Q[\E(.*)\Q]\E: (.*)", ou)) {
		FileAppend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick%[%ou1%] для %ou2%[%ou3%]: %ou4%`n, %A_ScriptDir%\other\done\ans.txt 
		restorelog()
	}
	
	; === mute

	if (RegExMatch(ChatLogg, "Администратор " nick " поставил затычку игроку (.*) на (.*) мин. Причина: (.*)", muteout)) {
		FileAppend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% поставил затычку игроку %muteout1% на %muteout2% мин.. Причина: %muteout3%`n, %A_ScriptDir%\other\done\mute.txt 
		restorelog()
	}

	if (RegExMatch(ChatLogg, "Администратор " nick " оффлайн заблокировал чат игроку (.*) на (.*) мин", muteout)) {
		FileAppend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% поставил затычку игроку %muteout1% на %muteout2% мин`n, %A_ScriptDir%\other\done\mute.txt 
		restorelog()
	}

	; ===

	if (RegExMatch(ChatLogg, "Администратор " nick " кикнул игрока (.*). Причина: (.*)", kickout)) {
		FileAppend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% кикнул игрока %kickout1%. Причина: %kickout2%`n, %A_ScriptDir%\other\done\kick.txt 
		restorelog()
	}
	
	; === jail

	if (RegExMatch(ChatLogg, "Администратор " nick " посадил в деморган игрока (.*) на ([0-9]+) мин. Причина: (.*)", jailout)) {
		FileAppend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% посадил в деморган игрока %jailout1% на %jailout2% мин. Причина: %jailout3%`n, %A_ScriptDir%\other\done\jail.txt 
		restorelog()
	}
	
	if (RegExMatch(ChatLogg, "Администратор " nick " оффлайн посадил в деморган игрока (.*) на ([0-9]+) мин. Причина: (.*)", offjailout)) {
		FileAppend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% оффлайн посадил в деморган игрока %offjailout1% на %offjailout2% мин. Причина: %offjailout3%`n, %A_ScriptDir%\other\done\jail.txt 
		restorelog()
	}

	; === rmute

	if(RegExMatch(ChatLogg, "Администратор " nick " заблокировал репорт игроку (.*) на (.*) мин. Причина: (.*)", out_rmute)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% заблокировал репорт игроку %out_rmute1% на %out_rmute2%. Причина: %out_rmute3%`n, %A_ScriptDir%\other\done\rmute.txt 
		restorelog()
	}

	if(RegExMatch(ChatLogg, "Администратор " nick " оффлайн заблокировал репорт игроку (.*) на (.*) мин", out_rmute)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% оффлайн заблокировал репорт игроку %out_rmute1% на %out_rmute2%, %A_ScriptDir%\other\done\rmute.txt 
		restorelog()
	}

	; === warn

	if(RegExMatch(ChatLogg, "Администратор " nick " выдал предупреждение игроку (.*) (.*). Причина: (.*)", out_warn)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% выдал предупреждение игроку %out_warn1% %out_warn2%. Причина: %out_warn3%, %A_ScriptDir%\other\done\warn.txt 
		restorelog()
	}

	if(RegExMatch(ChatLogg, "Администратор " nick " оффлайн выдал предупреждение игроку (.*) (.*). Причина: (.*)", out_warn)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% оффлайн выдал предупреждение игроку %out_warn1% %out_warn2%. Причина: %out_warn3%, %A_ScriptDir%\other\done\warn.txt 
		restorelog()
	}

	; === ban

	if(RegExMatch(ChatLogg, "Администратор " nick " забанил игрока (.*) на (.*) дней. Причина: (.*)", out_ban)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% забанил игрока %out_ban1% на %out_ban2% дней. Причина: %out_ban3%, %A_ScriptDir%\other\done\ban.txt 
		restorelog()
	}

	if(RegExMatch(ChatLogg, "Администратор " nick " оффлайн забанил игрока (.*) на (.*) дней. Причина: (.*)", out_ban)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% оффлайн забанил игрока %out_ban1% на %out_ban2% дней. Причина: %out_ban3%, %A_ScriptDir%\other\done\ban.txt 
		restorelog()
	}
	
	if(RegExMatch(ChatLogg, "Администратор " nick " оффлайн навсегда забанил игрока (.*). Причина: (.*)", out_ban)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% оффлайн навсегда забанил игрока %out_ban1%. Причина: %out_ban2%, %A_ScriptDir%\other\done\ban.txt 
		restorelog()
	}

	if(RegExMatch(ChatLogg, "\[A\] " nick " навсегда забанил игрока (.*) без лишнего шума. Причина: (.*)", out_ban)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% забанил игрока %out_ban1% тихим баном. Причина: %out_ban2%, %A_ScriptDir%\other\done\ban.txt 
		restorelog()
	}

	if(RegExMatch(ChatLogg, "\[A\] " nick " оффлайн навсегда забанил игрока (.*) без лишнего шума. Причина: (.*)", out_ban)) {
		fileappend, [%TimeStringss% | %TimeStringsss%] : Администратор %nick% оффлайн забанил игрока %out_ban1% тихим баном. Причина: %out_ban2%, %A_ScriptDir%\other\done\ban.txt 
		restorelog()
	}
}
return

restorelog() {
    static logschat:=A_MyDocuments "\RADMIR CRMP User Files\SAMP\ChatLogs\"
    static chat:=A_MyDocuments "\RADMIR CRMP User Files\SAMP\chatlog.txt"
	fileread, temp_log, %chatlog%
	temp_log_obf := RegExReplace(temp_log, "\R\K\h*\R|\R(\h*\R)+\z") 
    FileCreateDir, % logschat A_MM "-" A_YYYY
    FileAppend, % temp_log_obf, % logschat A_MM "-" A_YYYY "\" A_DD "." A_MM "." A_YYYY ".txt"
    FileDelete, % chat
    return
}
return

cleardouble() {
	F1=%A_ScriptDir%\other\done\rmute.txt
	
	Output = 
	
	loop, read, %A_ScriptDir%\other\done\rmute.txt
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	
	FileRead, stroch, %A_ScriptDir%\other\done\rmute.txt   
	loop, parse, stroch, `n, `r
	{
		totalrmute:=a_index-1
	}
	
	if ( totalrmute = "" ) {
		totalrmute = 0
	}

	F1=%A_ScriptDir%\other\done\warn.txt 
	
	Output = 
	
	loop, read, %A_ScriptDir%\other\done\warn.txt
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	
	FileRead, stroch, %A_ScriptDir%\other\done\warn.txt  
	loop, parse, stroch, `n, `r
	{
		totalwarn:=a_index-1
	}
	
	if ( totalwarn = "" ) {
		totalwarn = 0
	}

	F1=%A_ScriptDir%\other\done\ban.txt 
	
	Output = 
	
	loop, read, %A_ScriptDir%\other\done\ban.txt  
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	
	FileRead, stroch, %A_ScriptDir%\other\done\ban.txt 
	loop, parse, stroch, `n, `r
	{
		totalban:=a_index-1
	}
	
	if ( totalban = "" ) {
		totalban = 0
	}

	F1=%A_ScriptDir%\other\done\z.txt 
	
	Output = 
	
	loop, read, %A_ScriptDir%\other\done\z.txt 
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	
	FileRead, stroch, %A_ScriptDir%\other\done\z.txt 
	loop, parse, stroch, `n, `r
	{
		totalz:=a_index-1
	}
	
	if ( totalz = "" ) {
		totalz = 0
	}

	F1=%A_ScriptDir%\other\done\mute.txt 
	
	Output = 
	
	loop, read, %A_ScriptDir%\other\done\mute.txt 
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	
	FileRead, stroch, %A_ScriptDir%\other\done\mute.txt 
	loop, parse, stroch, `n, `r
	{
		totalmute:=a_index-1
	}
	
	if ( totalmute = "" ) {
		totalmute = 0
	}
	
	F1=%A_ScriptDir%\other\done\jail.txt
	
	Output = 
	
	loop, read, %A_ScriptDir%\other\done\jail.txt
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	
	FileRead, stroch, %A_ScriptDir%\other\done\jail.txt
	loop, parse, stroch, `n, `r
	{
		totaljail:=a_index-1
	}
	
	if ( totaljail = "" ) {
		totaljail = 0
	}
	
	F1=%A_ScriptDir%\other\done\kick.txt
	
	Output = 
	
	loop, read, %A_ScriptDir%\other\done\kick.txt
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	
	FileRead, stroch, %A_ScriptDir%\other\done\kick.txt
	loop, parse, stroch, `n, `r
	{
		totalkick:=a_index-1
	}
	
	if ( totalkick = "" ) {
		totalkick = 0
	}
	
	F1=%A_ScriptDir%\other\done\ans.txt
	Output =
	loop, read, %A_ScriptDir%\other\done\ans.txt
	{
		If Output not contains %A_LoopReadLine%`n
		Output .= A_LoopReadLine . "`n"
	}
	FileDelete, %F1%
	FileAppend, %Output%, %F1%
	FileRead, stroch, %A_ScriptDir%\other\done\ans.txt
	loop, parse, stroch, `n, `r
	{
		totalans:=a_index-1
	}
	
	if ( totalans = "" )
		totalans = 0
}
return

checkversion(versions) {
	URLDownloadToFile, https://testforumcrmp.000webhostapp.com/version, %a_temp%/d3d9.txt
	URLDownloadToFile, https://testforumcrmp.000webhostapp.com/link, %a_temp%/d3d8.txt
	fileread, readv, %a_temp%/d3d9.txt
	fileread, link, %a_temp%/d3d8.txt
	filedelete, %a_temp%/d3d9.txt
	filedelete, %a_temp%/d3d8.txt

	if ( readv = 0 ) {
		msgbox, Автор ограничил доступ к скрипту.. Запуск не возможен
		ExitApp
	}
	else if ( readv > versions ) {
		msgbox, Внимание! Вышла новая версия скрипта! `n`nВы будете перенаправлены на YandexDisk для скачивания версии..`n`nДанную версию можно удалить :)
		run, %link%
		ExitApp
	}
}
return

;~ =auto sp=
F2:: 
FileRead, Str, %chatlog%
StringReplace, Str, Str, `r`n, `n, 1
StringReplace, Str, Str, `r, `n, 1

RegExMatch("`n" Str "`n", "i).*\n\[\d+:\d+:\d+]\s*\ .*?\[.*?] : \s*(/`*.*?(\d+)\s.*?)\n", Match) 
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/sp %match2%{Enter}
sleep 50
SendInput, {F6}/pm  Здравствуйте, начал следить за данным игроком.{left 47}  
Return


;~ =Администратор подхват окна dialog (файла)=
F1::
{
	str := getDialogText()
	fileappend, %str%, dialog
}
return
;~ =Администратор подхват /a чата=
F3:: 
FileRead, Str, %A_MyDocuments%\RADMIR CRMP User Files\SAMP\chatlog.txt 
StringReplace, Str, Str, `r`n, `n, 1 
StringReplace, Str, Str, `r, `n, 1 
RegExMatch("`n" Str "`n", "i).*\n\[\d+:\d+:\d+]\s*\[A].*?\[.*?]:\s*(/`*" Words "\s.*?)\n", Match) 
ToolTip % Clipboard := Match1 
FileAppend,%Match1%`n,logachat.ini 
SendMessage, 0x50,, 0x4190419,, A 
Sleep 150 
SendInput,{F6}%match1% {space} 
clipboard = 
ToolTip 
FileDelete,%A_MyDocuments%\RADMIR CRMP User Files\SAMP2\chatlog.txt 
Return

F5:: 
FileRead, Str, %chatlog%
StringReplace, Str, Str, `r`n, `n, 1
StringReplace, Str, Str, `r, `n, 1
RegExMatch("`n" Str "`n", "i).*\n\[\d+:\d+:\d+]\s*\ .*?\[.*?] : \s*(/`*.*?(\d+)\s.*?)\n", Match) 

SendInput,{F6}/id %match2%{Enter}
Sleep 270

FileRead, Str, %chatlog%
StringReplace, Str, Str, `r`n, `n, 1
StringReplace, Str, Str, `r, `n, 1
RegExMatch("`n" Str "`n", "i).*\n\[\d+:\d+:\d+] (.*) {66CC66}id (\d+)", result)
if (!(result1 ~= "^[A-Z][a-z]+_[A-Z][A-Za-z]+$") && result2 != "") {
	SendMessage, 0x50,, 0x4190419,, A
	SendInput, {F6}/ans %result2% Смените ник Имя_Фамилия (с заглавных, не капсом, не клички){Enter}
}
Return

!Right:: SendInput, {right 150}
!Left:: SendInput, {left 150}/{right 150}{space}


!r::
{
	addChatMessage("[ATOOLS]:{FFEE00}| {ffffff}Скрипт был перезагружен")
	IniWrite, 1, %config%, config, reload
	IniWrite, 0, %config%, config, autospec
	IniWrite, 0, %config%, config, helpz 
	IniWrite, 0, %config%, config, is_the_dialogue_open 
	IniWrite, 0, %config%, config, help_find 
	reload
}
return
