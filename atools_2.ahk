buildscr = 11 ;версия для сравнения, если меньше чем в verlen.ini - обновляем
downlurl := "https://raw.githubusercontent.com/Cherdak1/Radmir/main/updt.exe"
downllen := "https://raw.githubusercontent.com/Cherdak1/Radmir/main/verlen.ini"

Utf8ToAnsii(ByRef Utf8String, CodePage = 1251)
{
If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
BOM = 3
Else
BOM = 0

UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
, "UInt", &Utf8String + BOM, "Int", -1
, "Int", 0, "Int", 0)
VarSetCapacity(UniBuf, UniSize * 2)
DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
, "UInt", &Utf8String + BOM, "Int", -1
, "UInt", &UniBuf, "Int", UniSize)

AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
, "UInt", &UniBuf, "Int", -1
, "Int", 0, "Int", 0
, "Int", 0, "Int", 0)
VarSetCapacity(AnsiString, AnsiSize)
DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
, "UInt", &UniBuf, "Int", -1
, "Str", AnsiString, "Int", AnsiSize
, "Int", 0, "Int", 0)
Return AnsiString
}
WM_HELP(){
IniRead, vupd, %a_temp%/verlen.ini, UPD, v
IniRead, desupd, %a_temp%/verlen.ini, UPD, des
desupd := Utf8ToAnsi(desupd)
IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
updupd := Utf8ToAnsi(updupd)
msgbox, , Список изменений версии %vupd%, %updupd%
return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd =
{
SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
sleep, 2000
}
if buildupd > % buildscr
{
IniRead, vupd, %a_temp%/verlen.ini, UPD, v
SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
sleep, 2000
IniRead, desupd, %a_temp%/verlen.ini, UPD, des
desupd := Utf8ToAnsi(desupd)
IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
updupd := Utf8ToAnsi(updupd)
SplashTextoff
msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
IfMsgBox OK
{
msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
IfMsgBox OK
{
put2 := % A_ScriptFullPath
RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
sleep, 1000
run, %a_temp%/updt.exe
exitapp
}
}
}
SplashTextoff
#IfWinActive GTA:SA:MP 
#SingleInstance Force 
#NoEnv 
#IfWinActive, ahk_exe gta_sa.exe
ListLines Off 
SetBatchLines -1 
chatlog := A_MyDocuments "\GTA San Andreas User Files\SAMP\chatlog.txt" 
FileDelete, %chatlog% 
Words = (kick|mute|jail|hp|unmute|unjail|sban|spcar|ban|warn|skick|o|unban|unwarn|offjail|banip|offban|offwarn|okay|slap|sp) s



if (A_IsAdmin = false) {
    Run *RunAs "%A_ScriptFullPath%" ,, UseErrorLevel
}

;//= Инклуды
#include samp-udf.ahk
#include CP.ahk
;//=
; === Регистрация команд
CMD.Register("faqtxt","faqtxt") ; +
CMD.Register("faqjail","faqjail") ; +
CMD.Register("faqmute","faqmute") ; +
CMD.Register("faqwarn","faqwarn") ; +
CMD.Register("faqban","faqban") ; +
CMD.Register("faq46","faq46") ; +
exit
;//=

return

;~ =Администратор стата=
Numpad1::
SendInput {F6}/atinfo
Return
;~ =Администратор инфа=
Numpad2::
SendInput {F6}/athelp
Return
;~ =Администратор стата удалить=
Numpad3::
SendInput {F6}/clearst
Return

Numpad7::
SendInput,{F6}/kick{Space}{Space}Смените ник /mn-10 Имя_Фамилия{Left 31}
return

;~ =Администратор команды=
Numpad0::
SendInput {F6}/admnakaz
Return

;~ ==========================================================================ATOOLS TAILS========================================================================== 
Numpad5::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/pm  {left 1}
var4:=var4+1
return 

NumpadDot::
SendInput,{F6}/pm  Здравствуйте, начал следить за данным игроком.{left 47} 
Return

Alt & NumpadDot::
SendInput,{F6}/pm  Не вижу нарушений от игрока.{left 29} 
Return

Numpad8::
SendInput,{F6}/pm  Уважаемый игрок,Смените ник в лаунчере.Форма ника:Имя_Фамилия.{left 62} 
return

Numpad9::
SendInput,{F6}/pm Подайте корректно жалобу в репорт (ID Нарушителя | Нарушение).{left 62} 
return


Home::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/jail {left 1}
sleep 1000
Return

Delete::
SendInput, {F6}/kick  Помеха{left 7} 
Sleep 500
Return

End::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/mute {left 1} 
sleep 1000
Return

Insert::
SendMessage, 0x50,, 0x4190419,, A 
SendInput,{F6}/pm  СМЕНИТЕ НИК Введите команду /mn — пункт 10 (ИЗМЕНИТЬ ИМЯ){left 58} 
var4:=var4+1
Return 

Alt & Insert::
SendMessage, 0x50,, 0x4190419,, A 
SendInput,{F6}/pm  Формат ника Имя_Фамилия (с заглавных, не капсом, не клички){left 60} 
var4:=var4+1
Return 

ScrollLock::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}
return

PgUp::
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/sp{Space} 
sleep 1000
Return

PgDn::
SendInput {F6}/fly{enter}
Sleep 500
Return

Break::
SendInput,{F6}/pm  Вы тут? Напишите в /n + или подвигайтесь{left 41} 
var4:=var4+1
return




#Persistent 
#SingleInstance FORCE 

Return 

;~ =для мп 4лвл адм=

Ctrl & Numpad1::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}/msg Уважаемые игроки, проходит МП "King of Desert Eagle", участвовать /tp{left 18} 
Return

Ctrl & Numpad5::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}/s Правила:(сбив анимаций,анимации,читы,аптечки\наркотики,перезаход в игру) - всё это ЗАПРЕЩЕНО!{left 18} 
Return


Ctrl & Numpad3::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}/msg Победитель МП "King of Desert Eagle" "" Он получает 25.000 Рублей{left 27} 
Return

Ctrl & Numpad4::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}/mp_gun 1 24 500{enter} 
Return

Ctrl & Numpad6::
SendMessage, 0x50,, 0x4190419,, A
SendInput,{F6}/mp_gun 2 24 500{enter} 
Return

;~ =Cкрипты быстрого ответа текст и пробел (Пример: аук и пробел и выдаст: Аукцион идет 24 часа, конец в 10 утра по МСК.)
;//= Окно НАЧАЛО
faqtxt() {
	
	str_dialog_faqtxt =
	
	(
{FF8129}тут1 {FFFFFF}Вы тут? Напишите в /n + или подвигайтесь
{FF8129}аук {FFFFFF}Аукцион идет 24 часа, конец в 10 утра по МСК.
{FF8129}неизв {FFFFFF}Неизвестно | Приятной игры на R-RP 04:)
{FF8129}бнв {FFFFFF}/family_leave | Приятной игры на R-RP 04:)
{FF8129}вых1 {FFFFFF}/leave
{FF8129}биз1 {FFFFFF}/gps-9
{FF8129}дс1 {FFFFFF}Официальный Discord: https://discord.gg/GBuGKY4
{FF8129}рп1 {FFFFFF}Узнайте Role Play путем (самостоятельно).
{FF8129}невыдаем {FFFFFF}Увы, мы не имеем право вмешиваться в РП процесс.
{FF8129}спавн {FFFFFF}/setspawn
{FF8129}рестарт1 {FFFFFF}Авторестарт сервера ежедневно проходит в 06:04 по МСК.
{FF8129}форум {FFFFFF}Форум проекта: forum.r-rp.ru
{FF8129}оффтоп {FFFFFF}Категорическая просьба воздержаться от оффтопа в репорт.
{FF8129}вопрос {FFFFFF}Сформулируйте пожалуйста корректный вопрос.
{FF8129}гос {FFFFFF}К сожалению, не могу сказать. Следите за гос. новостями. 
{FF8129}утиль {FFFFFF}Продать автомобиль можно в "Утилизации" - GPS [1-5]
{FF8129}дом {FFFFFF}/sellhome /sellmyhome
{FF8129}увал {FFFFFF}Ждите лидера/Зама. Увольнение с помощью адм. невозможно.
{FF8129}адм {FFFFFF}Администрация не выдает игровых привилегий. Заработайте сами. 
{FF8129}лиц {FFFFFF}Можно купить у лицензионеров.Найти их можно тут /liclist.
{FF8129}сайт {FFFFFF}Смотрите на офф.сайте r-rp.ru или в офф.группе в ВК.
{FF8129}промокод {FFFFFF}Узнайте самостоятельно в офф.группе vk.com/radmircrmp
{FF8129}жб {FFFFFF}Жалобу на форум (forum.r-rp.ru) с док-вами.
{FF8129}жб1 {FFFFFF}Если вы не согласны с наказанием, жалобу на форум.
{FF8129}ожид {FFFFFF}Ожидайте, в чате уведомлят.
{FF8129}баг {FFFFFF}Опишите баг на форум (forum.r-rp.ru) с док-вами.
{FF8129}нечиним {FFFFFF}Не чиним,механики на сервере. Вызовите их по номеру: /c 090
{FF8129}чат1 {FFFFFF}/fontsize /pagesize| Приятной игры на R-RP 04:)
{FF8129}время1 {FFFFFF}/timestamp | Приятной игры на R-RP 04:)
{FF8129}кон {FFFFFF}08:00, 12:00, 16:00, 20:00, 00:00 по МСК
{FF8129}номер {FFFFFF}/take_number | Приятной игры на R-RP 04:)
{FF8129}банда {FFFFFF}/family_create /gang_create | Приятной игры на R-RP 04:)
{FF8129}орж1 {FFFFFF}/makegun  | Приятной игры на R-RP 04:)
{FF8129}бон1 {FFFFFF}/bonus | Приятной игры на R-RP 04:)
{FF8129}жен1 {FFFFFF}/wedding /divorce | Приятной игры на R-RP 04:)
{FF8129}сделка {FFFFFF}Администрация не следит за сделками. Снимайте видео 
{FF8129}набор {FFFFFF}/events
{FF8129}МП1 {FFFFFF}Ожидайте, уведомления об МП в чате| Приятной игры на R-RP 04:)
{FF8129}маш1 {FFFFFF}/sellmycar [id] [цена] | Приятной игры на R-RP 04:)
{FF8129}кл1 {FFFFFF}/allow | Приятной игры на R-RP 04:)
{FF8129}ут1 {FFFFFF}Уточните
{FF8129}п1 {FFFFFF}/fixcar
{FF8129}г1 {FFFFFF}/goto
{FF8129}аф1 {FFFFFF}/kick  AFK 30 минут
{FF8129}аф2 {FFFFFF}/kick  Перезайдите
{FF8129}аф3 {FFFFFF}/kick  Помеха
	)
	
	
	showdialog(0, "Напоминалка | Быстрого ответа", str_dialog_faqtxt, "Закрыть")
}
return
;//= Окно конец

:?:тут1::Вы тут? Напишите в /n + или подвигайтесь
:?:аук::Аукцион идет 24 часа, конец в 10 утра по МСК.
:?:инв1::/give_Item
:?:сва:: Свалка 7:00, 11:00, 14:00, 19:00 (МСК)/GPS 8 > 12
:?:неизв::Неизвестно | Приятной игры на R-RP 04
:?:бнв::/family_leave | Приятной игры на R-RP 04
:?:вых1::/leave | Приятной игры на R-RP 04
:?:прив1::Здравствуйте | Приятной игры на R-RP 04
:?:помог1::Рад был вам помочь| Приятной игры на R-RP 04
:?:биз1::/gps-9 | Приятной игры на R-RP 04
:?:дс1::Официальный Discord:discord.com/invite/radmir04
:?:га1::Если у вас есть вопросы к ГА - https://vk.com/rm04rp
:?:рп1::Узнайте Role Play путем (самостоятельно).
:?:невыдаем::Увы, мы не имеем право вмешиваться в РП процесс.
:?:спавн::/setspawn - изменить место спавна
:?:рестарт1::Авторестарт сервера ежедневно проходит в 06:04 по МСК.
:?:форум::Форум проекта: forum.r-rp.ru
:?:оффтоп::Категорическая просьба воздержаться от оффтопа в репорт.
:?:вопрос::Сформулируйте пожалуйста корректный вопрос.
:?:гос::К сожалению, не могу сказать. Следите за гос. новостями. 
:?:чофф::Вопрос не по теме. Пример: А вы смотрели сегодня футбол?
:?:Бум1::/boombox_put -Поставить бумбокс,/boombox_pick -убрать бумбокс
:?:киоск1::/sellmystall >Продать игроку,/sellstall >Продать государству.
:?:утиль::Продать автомобиль можно в "Утилизации" - GPS [1-5]
:?:дом::/sellhome /sellmyhome
:?:крист1::Продать кристалы можно по /GPS > 8 > 20
:?:крист1::Продать кристалы можно по /GPS > 8 > 20
:?:адм3::На нашем сервере не продаются такие права.
:?:увал::Ждите лидера/Зама. Увольнение с помощью адм. невозможно.
:?:адм::Администрация не выдает игровых привилегий. Заработайте сами. 
:?:лиц::Можно купить у лицензионеров.Найти их можно тут /liclist.
:?:сайт::Смотрите на офф.сайте r-rp.ru или в офф.группе в ВК.
:?:промокод::Узнайте самостоятельно в офф.группе vk.com/radmircrmp
:?:жб::Жалобу на форум (forum.r-rp.ru) с док-вами.
:?:жб1::Если вы не согласны с наказанием, жалобу на форум.
:?:ожид::Ожидайте, в чате уведомлят.
:?:нчем::Нечем не могу вам помочь.
:?:нчем1::Т\С на ходу,доберитесь до блежайшего СТО.
:?:домнаколёсахменю1::/mhouse - Меню дома на колёсах.
:?:домнаколёсахвход1::/near_mhouse - возле входа
:?:домнаколёсахномер1::/evacuate_mhouse - номер дома
:?:огородменю1::/garden - меню огорода
:?:купитьогород1::/buygarden - купить огород
:?:продатьогород1::/sellgarden - продать огород игроку (продать в госс через меню)
:?:купитьогрод1::/buygarden - купить огород
:?:масло1::/change_oil - замена масла
:?:фильтр1::/change_filter - замена фильтра
:?:детали1::купить детали для замены можно в 24/7
:?:пейнтболвыход1::/paintball_exit - выйти с комнаты
:?:часынаручные1::/watch - посмотреть на часы(купить часы в сотовом салоне)
:?:скинпродать1:: /sellskin - продать скин
:?:удалитьскин1:: /dellskin - удалить из шкафа скин
:?:времяогорода1:: Огурцы - 30м, помидоры - час, марихуана 1:30 часа
:?:баг::Опишите баг на форум (forum.r-rp.ru) с док-вами.
:?:нечиним::Не чиним,механики на сервере. Вызовите их по номеру: /c 090
:?:чат1::/fontsize /pagesize | Приятной игры на R-RP 04
:?:время1::/timestamp  включить/выключить время в чате | Приятной игры на R-RP 04
:?:кон:: Контейнеры в 08:00, 12:00, 16:00, 20:00, 00:00(МСК)
/gps 2 > 8
:?:номер::/take_number снять номер | Приятной игры на R-RP 04
:?:банда::/family_create - создать семью /gang_create - создать банду | Приятной игры на R-RP 04
:?:орж1::/makegun - сделать оружие| Приятной игры на R-RP 04
:?:бон1::/bonus | Приятной игры на R-RP 04
:?:жен1::/wedding - заключить брак /divorce - расторгнуть брак | Приятной игры на R-RP 04
:?:сделка::Администрация не следит за сделками. Снимайте видео
:?:набор::/events | Приятной игры на R-RP 04
:?:МП1::Ожидайте, уведомления об МП в чате. | Приятной игры на R-RP 04
:?:маш1:: /sellmycar [id] [цена] | Приятной игры на R-RP 04
:?:кл1::/allow - передать ключи| Приятной игры на R-RP 04
:?:ут1::Уточните | Приятной игры на R-RP 04

;~ =Cкрипты быстрого доступа выдачи наказания текст и пробел (Пример: роск и пробел и выдаст: /rmute  Оск администратора)
:?:п1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /fixcar{Space} 
return 

:?:г1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /goto{Space} 
return 

:?:аф1:: 
SendInput, /kick  AFK 30 минут{Left 13} 
return 

:?:аф2:: 
SendInput, /kick  Перезайдите{Left 12} 
return 

:?:аф3:: 
SendInput, /kick  Помеха{Left 7} 
return 
;~ ==========================================================================JAIL==========================================================================
;//= Окно НАЧАЛО
faqjail() {
	
	str_dialog_faqjail =
	
	(
:?:апт1:: /jail  60 NonRP Аптечка				:?:апт2-5:: /jail  30 NonRP Аптечка(2-5 lvl)
:?:нган:: /jail  120 nonRP Оружие				:?:прокр:: /jail  30 NonRP(Прокрутка оружия)
:?:прокр2-5:: /jail  15 NonRP(Прокрутка оружия)(2-5 lvl)	:?:овч:: /warn  Один на ВЧ
:?:овч1:: /kick  Один на ВЧ(1 lvl)				:?:овч2-5:: /jail  120 Один на ВЧ(2-5 lvl)
:?:двч:: /warn  Двое на ВЧ					:?:двч1:: /kick  Двое на ВЧ(1 lvl)
:?:двч2-5:: /jail  120 Двое на ВЧ(2-5 lvl)				:?:вчм:: /warn  На ВЧ без маски
:?:вчм1:: /kick  На ВЧ без маски(1 lvl)				:?:вчм2-5:: /jail  120 На ВЧ без маски(2-5 lvl)
:?:тар:: /warn  NonRP езда(Таран)				:?:тар1:: /kick  NonRP езда(Таран)(1 lvl)
:?:тар2-5:: /jail  120 NonRP езда(Таран)(2-5 lvl)			:?:наркозз:: /jail  30 nonRP (наркотики в ЗЗ)
:?:нарко1:: /jail  60 nonRP наркотики				:?:нарко2:: /jail  120 nonRP наркотики
:?:дмм:: /jail  120 DM						:?:дм1:: /kick  DM(1 lvl)
:?:дм2-5:: /jail  60 DM(2-5 lvl)					:?:вх:: /jail  10 WH
:?:епп:: /jail  60 Езда по полям					:?:епп1:: /kick  Езда по полям(1 lvl)
:?:епп2-5:: /jail  30 Езда по полям(2-5 lvl)			:?:дым:: /jail  30 Езда с дымом
:?:дым1:: /jail  15 Езда с дымом				:?:кол:: /jail  30 Езда с пробитым колесом
:?:кол1:: /kick  Езда с пробитым колесом(1 lvl)		:?:кол2-5:: /jail  15 Езда с пробитым колесом(2-5 lvl)
:?:дб:: /jail  60 DB						:?:дб1:: /kick  DB(1 lvl
:?:дб2-5:: /jail  30 DB(2-5 lvl)					:?:нрппов:: /jail  60 nonRP поведение
:?:каз:: /jail  60 NonRP Казино					:?:каз1:: /kick  NonRP Казино(1 lvl)
:?:каз2-5:: /jail  30 NonRP Казино(2-5 lvl)			:?:срез:: /jail  30 NonRP езда(срез)
:?:срез1:: NonRP езда(срез)(1 lvl)				:?:срез2-5:: /jail   15 NonRP езда(срез)(2-5 lvl)
:?:угон:: /jail  30 nonRP Угон					:?:уходдтп:: /jail  120 Уход от ДТП
:?:толк1:: /jail  30 nonRP толкание авто			:?:маск1:: /jail  120 nonRP маска
:?:скилл:: /jail  120 nonRP качание скиллов оружия.		:?:красн:: /jail  60 Езда на красный свет светофора. 
:?:встр:: /jail  120 Езда по встречной полосе.{Left 29} 		:?:качзп:: /jail  120 Кач. ЗП[/]
:?:прогул:: /jail  120 Прогул раб.дня[/]
	)
	
	
	showdialog(0, "Напоминалка | Jail", str_dialog_faqjail, "Закрыть")
}
return
;//= Окно конец

:?:апт1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  60 NonRP Аптечка{Left 17} 
return 

:?:апт2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP Аптечка(2 lvl){Left 24} 
return 

:?:апт3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP Аптечка(3 lvl){Left 24} 
return 

:?:апт4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP Аптечка(4 lvl){Left 24} 
return 

:?:апт5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP Аптечка(5 lvl){Left 24} 
return 

:?:нган:: 
SendInput, /jail  120 nonRP Оружие{Left 17} 
return 

:?:прокр:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP(Прокрутка оружия){Left 27} 
return 

:?:прокр2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 NonRP(Прокрутка оружия)(2 lvl){Left 34} 
return 

:?:прокр3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 NonRP(Прокрутка оружия)(3 lvl){Left 34} 
return 

:?:прокр4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 NonRP(Прокрутка оружия)(4 lvl){Left 34} 
return 

:?:оскадм2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /rmute  360 Оск. Адм {Left 14} 
return 

:?:прокр5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 NonRP(Прокрутка оружия)(5 lvl){Left 34} 
return 

:?:овч:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /warn  Один на ВЧ{Left 11} 
return 

:?:овч1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  Один на ВЧ(1 lvl){Left 18} 
return 

:?:овч2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Один на ВЧ(2 lvl){Left 22} 
return 

:?:овч3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Один на ВЧ(3 lvl){Left 22} 
return 

:?:овч4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Один на ВЧ(4 lvl){Left 22} 
return 

:?:овч5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Один на ВЧ(5 lvl){Left 22} 
return 

:?:двч:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /warn  Двое на ВЧ{Left 11} 
return 

:?:двч1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  Двое на ВЧ(1 lvl){Left 18} 
return 

:?:двч2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Двое на ВЧ(2 lvl){Left 22} 
return 

:?:двч3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Двое на ВЧ(3 lvl){Left 22} 
return 

:?:двч4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Двое на ВЧ(4 lvl){Left 22} 
return 

:?:двч5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Двое на ВЧ(5 lvl){Left 22} 
return 

:?:вчм:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /warn  На ВЧ без маски {Left 16)
return 

:?:вчм1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  На ВЧ без маски(1 lvl){Left 23} 
return 

:?:вчм2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 На ВЧ без маски(2 lvl){Left 27} 
return 

:?:вчм3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 На ВЧ без маски(3 lvl){Left 27} 
return 

:?:вчм4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 На ВЧ без маски(4 lvl){Left 27} 
return 

:?:вчм5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 На ВЧ без маски(5 lvl){Left 27} 
return 

:?:тар:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /warn  NonRP езда(Таран){Left 18} 
return

:?:тар1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  NonRP езда(Таран)(1 lvl){Left 25} 
return 

:?:тар2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 NonRP езда(Таран)(2 lvl){Left 29} 
return 

:?:тар3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 NonRP езда(Таран)(3 lvl){Left 29} 
return 

:?:тар4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 NonRP езда(Таран)(4 lvl){Left 29} 
return 

:?:тар5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 NonRP езда(Таран)(5 lvl){Left 29} 
return

:?:наркозз::
SendInput, /jail  30 nonRP (наркотики в ЗЗ){Left 26}
return 

:?:нарко1:: 
SendInput, /jail  60 nonRP наркотики{Left 19} 
return 

:?:нарко2:: 
SendInput, /jail  120 nonRP наркотики{Left 20} 
return 

:?:дмм:: 
SendInput, /jail  120 DM{Left 7} 
return 

:?:дм1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  DM(1 lvl){Left 10} 
return 

:?:дм2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  60 DM(2 lvl){Left 13} 
return 

:?:дм3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  60 DM(3 lvl){Left 13} 
return 

:?:дм4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  60 DM(4 lvl){Left 13} 
return 

:?:дм5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  60 DM(5 lvl){Left 13} 
return 

:?:вх:: 
SendInput, /jail  10 WH{Left 6} 
return 

:?:епп:: 
SendInput, /jail  60 Езда по полям{Left 17} 
return 

:?:епп1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  Езда по полям(1 lvl){Left 21} 
return 

:?:епп2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 Езда по полям(2 lvl){Left 24} 
return 

:?:епп3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 Езда по полям(3 lvl){Left 24} 
return 

:?:епп4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail 30 Езда по полям(4 lvl){Left 24} 
return 

:?:епп5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 Езда по полям(5 lvl){Left 24} 
return 

:?:дым:: 
SendInput, /jail  30 Езда с дымом{Left 16} 
return 

:?:дым1:: 
SendInput, /jail  15 Езда с дымом{Left 16} 
return 

:?:кол:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 Езда с пробитым колесом{Left 27} 
return 

:?:кол1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  Езда с пробитым колесом(1 lvl){Left 31} 
return 

:?:кол2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 Езда с пробитым колесом(2 lvl){Left 34} 
return 

:?:кол3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 Езда с пробитым колесом(3 lvl){Left 34} 
return 

:?:кол4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 Езда с пробитым колесом(4 lvl){Left 34} 
return 

:?:кол5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  15 Езда с пробитым колесом(5 lvl){Left 34} 
return 

:?:дб:: 
SendInput, /jail  60 DB{Left 6} 
return 

:?:дб1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  DB(1 lvl){Left 10} 
return 

:?:дб2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 DB(2 lvl){Left 13} 
return 

:?:дб3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 DB(3 lvl){Left 13} 
return 

:?:дб4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 DB(4 lvl){Left 13} 
return 

:?:дб5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 DB(5 lvl){Left 13} 
return 

:?:нрппов:: 
SendInput, /jail  60 nonRP поведение{Left 18} 
return 

:?:каз:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  60 NonRP Казино{Left 16} 
return 

:?:каз1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick  NonRP Казино(1 lvl){Left 20} 
return 

:?:каз2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP Казино(2 lvl){Left 23} 
return 

:?:каз3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP Казино(3 lvl){Left 23} 
return 

:?:каз4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP Казино(4 lvl){Left 23} 
return 

:?:каз5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail   30 NonRP Казино(5 lvl){Left 23} 
return 


:?:срез:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  30 NonRP езда(срез){Left 20} 
return 

:?:срез1:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /kick   NonRP езда(срез)(1 lvl){Left 24} 
return 

:?:срез2:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail   15 NonRP езда(срез)(2 lvl){Left 27} 
return 

:?:срез3:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail   15 NonRP езда(срез)(3 lvl){Left 27} 
return 

:?:срез4:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail   15 NonRP езда(срез)(4 lvl){Left 27} 
return
 
:?:срез5:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail   15 NonRP езда(срез)(5 lvl){Left 27} 
return 

:?:угон:: 
SendInput, /jail  30 nonRP Угон{Left 14} 
return 

:?:уходдтп:: 
SendInput, /jail  120 Уход от ДТП{Left 16} 
return 


:?:толк1:: 
SendInput, /jail  30 nonRP толкание авто{Left 23} 
return 

:?:маск1:: 
SendInput, /jail  120 nonRP маска{Left 16} 
return 

:?:скилл::
SendInput, /jail  120 nonRP качание скиллов оружия.{Left 34}
return 

:?:красн:: 
SendInput, /jail  60 Езда на красный свет светофора.{Left 35} 
return 

:?:встр:: 
SendInput, /jail  120 Езда по встречне полосе.{Left 29} 
return

:?:качзп:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Кач. ЗП[/]{Left 15} 
return 

:?:прогул:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /jail  120 Прогул раб.дня[/]{Left 22} 
return 
;~ ==========================================================================MUTE==========================================================================
;//= Окно НАЧАЛО
faqmute() {
	
	str_dialog_faqmute =
	
	(
:?:роск:: /rmute  Оск администратора
:?:мат:: /mute  60 Мат в OOC
:?:флуд::/mute  30 Flood
:?:мг:: /mute  60 MG
:?:оск:: /mute  60 Оск в ООС
:?:едит:: /mute  120 NonRp /edit
:?:эфир:: /mute  30 /efir
:?:флуд1:: /rmute  30 Оффтоп в репорт
:?:родн:: /mute  360 Упом родных
	)
	
	
	showdialog(0, "Напоминалка | Mute", str_dialog_faqmute, "Закрыть")
}
return
;//= Окно конец
 
:?:роск:: 
SendMessage, 0x50,, 0x4190419,, A 
SendInput, /rmute  Оск администратора{Left 19} 
return 

:?:мат:: 
SendInput, /mute  60 Мат в OOC{Left 13} 
return 

:?:флуд::
SendInput, /mute  30 Flood{Left 9} 
return 

:?:мг:: 
SendInput, /mute  60 MG{Left 6} 
return 

:?:оск:: 
SendInput, /mute  60 Оск в ООС{Left 14} 
return 

:?:едит:: 
SendInput, /mute  120 NonRp /edit{Left 16} 
return 

:?:эфир:: 
SendInput, /mute  30 /efir{Left 9} 
return 

:?:флуд1::
SendInput, /rmute  30 Оффтоп в репорт{Left 19} 
return 

:?:родн:: 
SendInput, /mute  360 Упом родных{Left 16} 
return 

;~ ==========================================================================WARN========================================================================== 
;//= Окно НАЧАЛО
faqwarn() {
	
	str_dialog_faqwarn =
	
	(
:?:бгз:: /warn  багоюз
:?:медик:: /warn  nonRP врач
:?:тк1:: /warn  TK
:?:ск1:: /warn  SK
:?:с1:: /warn  Багаюз плюс (С)
:?:дмз:: /warn  DM in ZZ
:?:тие1:: /warn  /tie in ZZ
:?:нтие:: /warn  nonRP /tie
:?:уход:: /warn  Уход от RP
:?:взломм:: /warn  Взлом авто без маски
:?:взлом1:: /warn  Взлом авто в одного
	)
	
	
	showdialog(0, "Напоминалка | Warn", str_dialog_faqwarn, "Закрыть")
}
return
;//= Окно конец

:?:бгз:: 
SendInput, /warn  багоюз{Left 7} 
return  

:?:медик:: 
SendInput, /warn  nonRP врач{Left 11} 
return 

:?:тк1:: 
SendInput, /warn  TK{Left 3} 
return 

:?:ск1:: 
SendInput, /warn  SK{Left 3} 
return 

:?:с1:: 
SendInput, /warn  Багаюз плюс (С){Left 16} 
return 

:?:дмз:: 
SendInput, /warn  DM in ZZ{Left 9} 
return 

:?:тие1:: 
SendInput, /warn  /tie in ZZ{Left 11} 
return 

:?:нтие:: 
SendInput, /warn  nonRP /tie{Left 11} 
return 

:?:уход:: 
SendInput, /warn  Уход от RP{Left 11} 
return 

:?:взломм:: 
SendInput, /warn  Взлом авто без маски{Left 21} 
return 

:?:взлом1:: 
SendInput, /warn  Взлом авто в одного{Left 20} 
return 

;~ ==========================================================================BAN===================================================

======================= 
;//= Окно НАЧАЛО
faq46() {
	
	str_dialog_faq46 =
	
	(
домнаколёсахменю1:: /mhouse - Меню дома на колёсах.
домнаколёсахвход1::/near_mhouse - возле входа
домнаколёсахномер1::/evacuate_mhouse - номер дома
огородменю1::/garden - меню огорода
купитьогород1::/buygarden - купить огород
продатьогород1::/sellgarden - продать огород игроку (продать в госс через меню)
купитьогрод1::/buygarden - купить огород
масло1::/change_oil - замена масла
фильтр1::/change_filter - замена фильтра
детали1::купить детали для замены можно в 24/7
пейнтболвыход1::/paintball_exit - выйти с комнаты
часынаручные1::/watch - посмотреть на часы(купить часы в сотовом салоне)
скинпродать1:: /sellskin - продать скин
удалитьскин1:: /dellskin - удалить из шкафа скин
времяогорода1:: Огурцы - 30м, помидоры - час, марихуана 1:30 часа
	)
	
	
	showdialog(0, "Напоминалка | Ban", str_dialog_faq46, "Закрыть")
}
return

faqban() {
	
	str_dialog_faqban =
	
	(
:?:бддм:: /ban  5 DM in ZZ (Банда)
:?:6на6:: /ban  10 nonRP (таран 6x6)
:?:4на4:: /ban  10 nonRP (таран 4x4)
:?:чит1:: /sban  Cheat
:?:оскродн:: /ban  30 Оск. родных
:?:пвп:: /ban  30 Продан/Взломан/Передан
:?:обман:: /ban  30 Обман игроков
	)
	
	
	showdialog(0, "Напоминалка | Ban", str_dialog_faqban, "Закрыть")
}
return
;//= Окно конец


:?:бддм:: 
SendInput, /ban  5 DM in ZZ (Банда){Left 19} 
return 

:?:6на6:: 
SendInput, /ban  10 nonRP (таран 6x6){Left 17} 
return 

:?:4на4:: 
SendInput, /ban  10 nonRP (таран 4x4){Left 17} 
return 

:?:чит1:: 
SendInput, /sban  Cheat{Left 6} 
return 

:?:оскродн:: 
SendInput, /ban  30 Оск. родных{Left 15} 
return 

:?:пвп:: 
SendInput, /ban  30 Продан/Взломан/Передан{Left 26} 
return 

:?:обман:: 
SendInput, /ban  30 Обман игроков{Left 17} 
return 
