#SingleInstance Force
#Persistent
#Include udf.ahk
#IfWinActive GTA:SA:MP

buildscr = 5
downlurl := "https://github.com/MindstormsLego/Radiant-Mass-Media/blob/master/updt.exe?raw=true"
downllen := "https://raw.githubusercontent.com/MindstormsLego/Radiant-Mass-Media/master/updates.ini"
WM_HELP()
{
    IniRead, vupd, %a_temp%/updates.ini, UPDATES, v
    IniRead, desupd, %a_temp%/updates.ini, UPDATES, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/updates.ini, UPDATES, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}
OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs
SplashTextOn, , 130,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/updates.ini
IniRead, buildupd, %a_temp%/updates.ini, UPDATES, build
if buildupd =
{
    SplashTextOn, , 130,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/updates.ini, UPDATES, v
    SplashTextOn, , 130,Автообновление, Запуск скрипта. Процесс...`nОбнаружена новая версия скрипта %vupd%.
    sleep, 2000
    IniRead, desupd, %a_temp%/updates.ini, UPDATES, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/updates.ini, UPDATES, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли скачать последние обновления?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 120,Автообновление скрипта, Обновление. Процесс...`nОбновляем скрипт до версии %vupd%.
            URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
            sleep, 1000
            run, %a_temp%/updt.exe
            exitapp
        }
    }
}
SplashTextoff

WinWaitActive, GTA:SA:MP
{
    addChatMessageEx("B8DBB8" , "{CCCCCC}Script {B8DBB8}Mass Media Master {CCCCCC}запущен и находится в активном режиме.") 
    Sleep, 50
    addChatMessageEx("B8DBB8" , "{CCCCCC}Полная навигация по скрипту: Клавиша {B8DBB8}F4 {CCCCCC}, а также команда {B8DBB8}/cmd.") 
}

global goThenSobes := "[Alt + 1]: {CCCCCC}Продолжить. {FF7F50}[Alt + 9]: {CCCCCC}Отказать в собеседовании. {FF7F50}[F12]: {CCCCCC}Перезагрузить скрипт."
global goThenJob := "[Alt + 1]: {CCCCCC}Ответ положительный. {FF7F50}[Alt + 9]: {CCCCCC}Ответ отрицательный. {FF7F50}[F12]: {CCCCCC}Перезагрузить скрипт."
global Helper := "[F11]: {CCCCCC}Возможные дальнейшие действия."

CommandText =
   (
{00FF99}F12 {FFFFFF}- Перезагрузить скрипт (в случае багов)
{00FF99}Alt + F12 {FFFFFF}- Полностью отключить скрипт.
    
{00FF99}/cfind {FFFFFF}- Чекер отсутствующих сотрудников организации в зоне прорисовки. {cccccc}[c 7 ранга]
{00FF99}/proc {999999}[id] {FFFFFF}- Role-Play Invite/Uninvite/Rang/Fwarn/SetSkin. {cccccc}[с 8 ранга]
{00FF99}/sobes {999999}[id] {FFFFFF}- Начало собеседования.
{00FF99}/exam {999999}[id] {FFFFFF}- Начало экзамена.
{00FF99}/gotosobes {999999}[id] {FFFFFF}- Перейти на другой сценарий собеседования.
{00FF99}/gotoexam {999999}[id] {FFFFFF}- Перейти на другой сценарий приёма экзамена.
   )

F12::
PrintLow("~g~Script Reload", "250") 
Reload
Return

!F12::
addChatMessageEx("B8DBB8" , "[AHK]: Cкрипт был деактивирован.")
ExitAPP
Return

:?:/rn::/r (( )){left 3}
:?:/fn::/f (( )){left 3}

:?:/f::
IniRead, IniTag, settings.ini, sectionTeg, IniTag
SendMessage, 0x50,, 0x4190419,, A
SendInput /f %IniTag% •{Space}
return

:?:/cmd::
ShowDialog("0", "{269BD8}Commands", CommandText , "Ок")
return

F4::
SexPerson()
IniRead, IniTag, settings.ini, sectionTeg, IniTag
if !IniTag
    IniTag := "- "
showDialog(2, "{FF5F10}AutoHotkey for Mass Media" , "{FF5F10}• {FFFFFF}Разнос газет.`n{FF5F10}• {FFFFFF}Раздача листовок`n{FF5F10}• {FFFFFF}Лекции в [R] рацию`n{FF5F10}• {FFFFFF}Радиоэфир`n{FF5F10}• {FFFFFF}Телеэфир`n{FF5F10}• {FFFFFF}Дополнительные команды`n{FF5F10}• {FFFFFF}Авторы`n{FF5F10}• {FFFFFF}Настройка тэга [ На данный момент: {B8DBB8}" IniTag "{FFFFFF} ]", "Ок")
Result := LineResult()
if !(Result)
    return
Gosub, Labe%Result%
return

Labe1: ; Газеты
ArrayToSendChat(2300,["/do Газеты в сумке."
                     ,"/me открыл" RP1 " сумку, после чего достал" RP1 " оттуда газету"
                     ,"/me положил" RP1 " газету около дверного входа"
                     ,"/do На газете написано 'Новости недели'."
                     ,"/me закрыл" RP1 " сумку"])
sleep 500
SendChat("/time")
sleep 500
Send {F8}
return

Labe2: ; Листовки
ArrayToSendChat(2300,["/me достал" RP1 " листовку из рюкзака"
                     ,"/todo Переключайтесь на радиоволну " Town() ". Лучшие эфиры и викторины!       *вежливо улыбнувшись"
                     ,"/me передал" RP1 " листовку человеку напротив"])
sleep 500
SendChat("/time")
sleep 500
Send {F8}
return

Labe3: ; Лекции в [R] рацию.
showDialog(2, "{FF5F10}Сборник лекций" , "{FF5F10}• {FFFFFF}Дресс-код`n{FF5F10}• {FFFFFF}Транспорт`n{FF5F10}• {FFFFFF}Субординация`n{FF5F10}• {FFFFFF}Рабочий график`n{FF5F10}• {FFFFFF}Некорректное объявление`n{FF5F10}• {FFFFFF}Мероприятия в рабочее время`n{FF5F10}• {FFFFFF}Отчёты и повышение", "Ок")
Result := LineResult()
if !(Result)
    return
if (Result == 1)          ;/r 123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890 - максимальная длина в /r до переноса строки.
    ArrayToSendChat(2500,["/r Уважаемые коллеги, минуточку внимания. Лекция на тему « Дресс-код »."
                         ,"/r Дресс-код должен соблюдаться всеми сотрудниками"
                         ,"/r Разрешается снимать рабочую форму в обеденное временя."
                         ,"/r За нарушение дресс-кода сотруднику будет выдано устное предупреждение"
                         ,"/r При последующем нарушении - выговор."
                         ,"/r Лекция окончена, благодарю за внимание."])
else if (Result == 2)
    ArrayToSendChat(2500,["/r Уважаемые коллеги, минуточку внимания. Лекция на тему « Транспорт »."
                         ,"/r Брать служебный транспорт без спроса Руководящего состава - запрещено."
                         ,"/r Так же при разрешении, запрещено использовать служебный транспорт в личных целях."
                         ,"/r Рабочий транспорт свободно разрешён с должности « Репортёра »"
                         ,"/r Служебный вертолёт с должности « Режиссёра »"
                         ,"/r Лекция окончена, благодарю за внимание."])
else if (Result == 3)
    ArrayToSendChat(2500,["/r Уважаемые коллеги, минуточку внимания. Лекция на тему « Субординация »."
                         ,"/r Субординация - система строгого служебного подчинения младшего состава."
                         ,"/r Она предусматривает уважительные отношения между начальником и подчинённым."
                         ,"/r В гос.организациях правила субординации устанавливают порядок общения"
                         ,"/r К старшим по должности необходимо обращаться на « Вы »"
                         ,"/r Лекция окончена, благодарю за внимание."])
else if (Result == 4)
    ArrayToSendChat(2500,["/r Уважаемые коллеги, минуточку внимания. Лекция на тему « Рабочий график »."
                         ,"/r Рабочий график по будням: с 10:00 до 20:00."
                         ,"/r Обеды: с 13:00 до 14:00 и c 17:00 до 18:00."
                         ,"/r Рабочий график по выходным: с 10:00 до 19:00."
                         ,"/r Обеды: с 13:00 до 14:00"
                         ,"/r Лекция окончена, благодарю за внимание."])
else if (Result == 5)
    ArrayToSendChat(2500,["/r Уважаемые коллеги, минуточку внимания. Лекция на тему « Некорректное объявление »."
                         ,"/r Если Вы случайно отредактировали отобъявление некорректно - не нужно огорчаться."
                         ,"/r Независимо от вашей должности, вы имеете право обратиться в общую рацию."
                         ,"/r И извиниться за свой проступок. Тогда вы не получите наказания."
                         ,"/r Лекция окончена, благодарю за внимание."])
else if (Result == 6)
    ArrayToSendChat(2500,["/r Уважаемые коллеги, минуточку внимания. Лекция на тему « Мероприятия в рабочее время »."
                         ,"/r Во время рабочего дня запрещается ходить на различные мероприятия."
                         ,"/r А именно: Казино, Бейсджампинг, Гонки, Пейнтболл."
                         ,"/r За нарушение данного правила сотрудник будет наказан предупреждением или выговором."
                         ,"/r Лекция окончена, благодарю за внимание."])  
else if (Result == 7)
    ArrayToSendChat(2500,["/r Уважаемые коллеги, минуточку внимания. Лекция на тему « Отчёты и повышение »."
                         ,"/r Для успешного продвижения по карьерной лестнице нужно проделывать отчёт своей работы."
                         ,"/r (( А именно, делать необходимые скриншоты, согласно норме на повышение ))"
                         ,"/r (( Найти данную норму можно на форуме, в разделе СМИ ""Полезная информация"" ))"
                         ,"/r После одобрения отчёта, репортёры и выше получают повышение на общем собрании."
                         ,"/r Помощники редакции и Светотехники получают должность внеочереди."
                         ,"/r Лекция окончена, благодарю за внимание."])               
sleep 500
SendChat("/time")
sleep 500
Send {F8}
return

Labe4: ; Раздел для радиоэфира.
{
    showDialog(2, "{FF5F10}Радиоэфир" , "{FF5F10}• {FFFFFF}Начать эфир`n{FF5F10}• {FFFFFF}Процесс вещания`n{FF5F10}• {FFFFFF}Закончить эфир", "Ок")
    Result := LineResult()
    if !(Result)
        return
    Gosub, RadioEfir%Result%
}
return

Labe5: ; Раздел для телеэфира.
{
    showDialog(2, "{FF5F10}Телеэфир" , "{FF5F10}• {FFFFFF}Начать телеэфир`n{FF5F10}• {FFFFFF}Процесс вещания`n{FF5F10}• {FFFFFF}Выдать микрофон`n{FF5F10}• {FFFFFF}Закончить телеэфир", "Ок")
    Result := LineResult()
    if !(Result)
        return
    Gosub, TeleEfir%Result%
}
return

Labe6: ; Дополнительные команды.
ShowDialog("0", "{269BD8}Commands", CommandText , "Ок")
return

Labe7: ; Об авторах.
showDialog(0, "Об авторах" , "{42aaff}• {FFFFFF}Adam_Rockwell - {42aaff}vk.com/id127896497`n{42aaff}• {FFFFFF}Mike_Nagano - {42aaff}vk.com/mikenaganotop", "Ок")
return

Labe8: ; Настройки тэга.
showDialog("1", "{FF5F10}Изменение тэга", "{FFFFFF}Введите тэг вашего радиоцентра.`nДля отмены оставьте поле пустым и нажмите Enter.", "Ок")
input, text, V, {Enter}
if text
{
   iniwrite, %text%, settings.ini, sectionTeg, IniTag
    addChatMessageEx("B8DBB8","[AHK]: Тэг {FFFFFF}""" text """ {B8DBB8}успешно сохранён.")
}
else Exit
return

RadioEfir1: ; Начать радиоэфир.
ArrayToSendChat(2200,["/me взял" RP1 " микрофон и наушники"
					 ,"/me надел" RP1 " наушники на голову"
					 ,"/me настроил" RP1 " звуковую дорожку"
					 ,"/me настроил" RP1 " оборудование"
					 ,"/me приготовил" RP4 " к выходу в эфир"
					 ,"/me запустил" RP1 " эфир", "/ether"])
SendChat("/time")
sleep 500
Send {F8}
return

RadioEfir2: ; Процесс радиоэфира.
showDialog(1, "{FF5F10}Процесс вещания" , "{FFFFFF}Введите название секции ini файла`nв которой находятся строки с текстом.`nДля отмены оставьте поле пустым и нажмите Enter.", "Ок")
input, sect, V, {Enter}
if sect
{
	c := 0
	Loop
	{
		IniRead, str%A_Index%, settings.ini, %sect%, str%A_Index%
		if str%A_Index% = Error
		   break
		else
		{
			c++
			SendChat(str%A_Index%)
			sleep 2200
		}
	}
	if c = 0
	   addChatMessageEx("CCCCCC","Секция {B8DBB8}" sect "{CCCCCC} не найдена в settings.ini")
}
else Exit
return

RadioEfir3: ; Закончить радиоэфир.
ArrayToSendChat(2200,["/ether"
					 ,"/me " RP5 " из эфира"
					 ,"/me убрал" RP1 " оборудование на место"
					 ,"/me выключил" RP1 " оборудование"])
SendChat("/time")
sleep 500
Send {F8}
return

TeleEfir1: ; Установка камеры для телеэфира.
ArrayToSendChat(2200,["/do На правом плече весит сумка с камерой, проводами и штативом."
                     ,"/me протянул" RP4 " к сумке, после чего снял" RP1 " её с плеча"
                     ,"/do Сумка с камерой, проводами, штативом в руке."
                     ,"/me открыл" RP1 " сумку, после чего достал" RP1 " штатив"
                     ,"/me установил" RP1 " штатив, поставив его в нужное место"
                     ,"/me уставливает камеру на штатив"])
SendChat("/time")
sleep 500
Send {F8}
sleep 1500
SendChat("/tvmenu")
while !(isDialogOpen() && getDialogCaption() = "Телеэфир")
    continue
sleep 200
SendInput {enter}
while isDialogOpen()
    continue
sleep 300
ArrayToSendChat(2200,["/do Камера установлена."
                     ,"/me достал" RP1 " провода, после чего подключил" RP1 " их к планшету"
                     ,"/do На планшете вышло окно « Сеть готова к подключению »."
                     ,"/me нажал" RP1 " на кнопку <Rec>, после чего пошла запись"])
SendChat("/tvmenu")
while !(isDialogOpen() && getDialogCaption() = "Телеэфир")
    continue
sleep 200
SendInput {down 2}{enter}
while !(isDialogOpen() && getDialogCaption() = "ТВ-Эфир")
    continue
sleep 200
while isDialogOpen()
    continue
sleep 500
SendChat("/do Запись идет.")
SendChat("/time")
sleep 500
Send {F8}
return

TeleEfir2: ; Процесс телеэфира.
showDialog(1, "{FF5F10}Процесс вещания" , "{FFFFFF}Введите название секции ini файла`nв которой находятся строки с текстом.`nДля отмены оставьте поле пустым и нажмите Enter.", "Ок")
input, sect, V, {Enter}
if sect
{
	c := 0
	Loop
	{
		IniRead, str%A_Index%, settings.ini, %sect%, str%A_Index%
		if str%A_Index% = Error
		   break
		else
		{
			c++
			SendChat("/tv " str%A_Index%)
			sleep 2200
		}
	}
	if c = 0
	   addChatMessageEx("CCCCCC","Секция {B8DBB8}" sect "{CCCCCC} не найдена в settings.ini")
}
else Exit
return

TeleEfir3: ; Выдача микрофона.
showDialog(1, "{FF5F10}Выдача микрофона" , "{FFFFFF}Введите ID игрока.`nДля отмены оставьте поле пустым и нажмите Enter.", "Ок")
input, id, V, {Enter}
if id
{
	showDialog(1, "{FF5F10}Выдача микрофона" , "{FFFFFF}Введите причину выдачи микрофона.`nДля отмены оставьте поле пустым и нажмите Enter.", "Ок")
	input, text, V, {Enter}
	if text
	{
		IniRead, IniTag, settings.ini, sectionTeg, IniTag
		SendChat("/me открыл сумку, после чего достал из нее микрофон")
		Sleep 2200
		SendChat("/do Микрофон в руке.")
		Sleep 2200
		SendChat("/me передал микрофон " RegExReplace(getPlayerNameById(id),"_"," "))
		SendChat("/tvmenu")
		while !(isDialogOpen() && getDialogCaption() = "Телеэфир")
			continue
		sleep 200
		SendInput {down 4}{enter}
		while !(isDialogOpen() && getDialogCaption() = "ТВ-Микрофон")
			continue
		sleep 200
		SendInput %id%{enter}
		while isDialogOpen()
			continue
		sleep 500
		SendChat(" /f " IniTag " • Выдал микрофон " RegExReplace(getPlayerNameById(id),"_"," ") ". Причина: " text)
	}
	else Exit
}
else Exit
return

TeleEfir4: ; Разборка камеры после телеэфира.
ArrayToSendChat(2200,["/me протянул" RP4 " к планшету повторно нажал на кнопку <Rec>"
					 ,"/do На планшете вышло окно « Подключение отключено »."
					 ,"/do Камера прекратила запись."
					 ,"/me отсоединил" RP1 " провода от камеры"
                     ,"/me отсоединил" RP1 " камеру от штатива"
                     ,"/me положил" RP1 " провода и камеру в сумку"])
SendChat("/time")
sleep 500
Send {F8}
sleep 1500
SendChat("/tvmenu")
while !(isDialogOpen() && getDialogCaption() = "Телеэфир")
    continue
sleep 200
SendInput {down 3}{enter}
while isDialogOpen()
    continue
ArrayToSendChat(2200,["/me убрал" RP1 " камеру и штатив в сумку"
					 ,"/me убрал" RP1 " планшет в карман"])
SendChat("/time")
sleep 500
Send {F8}
return

$~vkD::
if (IsInChat() && !IsDialogOpen()) 
{
    Sleep, 170
    dwAddress := dwSAMP + 0x12D8F8
    chatInput := readString(hGTA, dwAddress, 256)
    Sleep, 30
;===========
;===========
;===========
if (RegExMatch(chatInput, "i)^\/proc"))
{
   if (RegExMatch(chatInput, "i)^\/proc (\d{1,3})", value))
   {
      id := value1
      name := getPlayerNameById(id)
      ShowDialog(2, name " [" id "]" , "Принять в организацию`nУволить из организации`nВыдать выговор`nПовысить`nВыдать новую форму", "Ок")
      Result := LineResult()
      if (!Result)
         return
      SexPerson()
      Gosub, JobFunction%Result%
   }
   else
      addchatmessageEx("AAAAAA" , "/proc [id]")
}
else
;===========
;===========
;===========
if (RegExMatch(chatInput, "i)^\/cfind"))
{
	SexPerson()
	ArrayRangs := ["Начинающий работник" , "Помощник редакции" , "Светотехник" , "Репортёр" , "Оператор" , "Ведущий"]
	ArrayNotStreamPlayer := []
	SendChat("/find")
	while !(isDialogOpen() && getDialogCaption() = "{ffff00}Члены организации онлайн")
		continue
	Loop
	{
		if getDialogLine(A_Index+3)
		{
			if RegExMatch(getDialogLine(A_Index+3), "(\d{1,3}).*\s(\d{1,2})\s+\d{1,1}/3", value) and (getTargetPlayerSkinIdById(value1) = -1)
			{
				if (value1 <> getId()) and (value2 < 7)
					ArrayNotStreamPlayer.Insert([value1,value2])
				else if (value1 = getId()) 
					myRang := value2
			}
		}
		else break
	}
	SendInput {enter}
	if (myRang < 7)
	{
		addChatMessageEx("FFFFFF","• {AC0000}[Ошибка] {FFFFFF}Данная функция доступна с должности Режиссёр [7].")
		Exit
	}
	if ArrayNotStreamPlayer.Length() = 0
	{
		addChatMessageEx("B8DBB8" , "Все сотрудники на месте.")
	}
	else
	{
		addChatMessageEx("FFFFFF" , "Отсутствующие cотрудники:")
		ArrayOutputForCfind(ArrayNotStreamPlayer,4)
		sleep 500
		addChatMessageEx("B8DBB8" , "[F11]: {CCCCCC}Нажмите в течении 5 секунд для продолжения.")
		KeyWait, F11, D T5
		if !(ErrorLevel)
		{
			addChatMessageEx("8888FF" , "[1]: {CCCCCC}Проговорить быстро. {8888FF}[2]: {CCCCCC}Проговорить медленно.")
			sleep 100
			addChatMessageEx("8888FF" , "[3]: {CCCCCC}Проговорить в [R] рацию. {8888FF}[4]: {CCCCCC}Отмена.")
			Loop
			{
				Input , OutputVar, L1 V, {1}{2}{3}{4}
				if (ErrorLevel = "EndKey:1") or (ErrorLevel = "EndKey:2") or (ErrorLevel = "EndKey:3") or (ErrorLevel = "EndKey:4")
					break
			}
			if ErrorLevel = EndKey:1
			{
				SendChat("Отсутствующие cотрудники:")
				sleep 1200
				For v, pair in ArrayNotStreamPlayer
				{
					ArrayRangsFuction(pair[2],ArrayRangs,position)
					SendChat(position " " RegExReplace(getPlayerNameById(pair[1]), "_", " ") " [Жетон №" pair[1] "]")
					sleep 1000
				}
			}
			else if ErrorLevel = EndKey:2
			{
				SendChat("/me орлиным взглядом осмотрел" RP1 " всех сотрудников вокруг себя")
				sleep 2300
				SendChat("/me произвел" RP1 " расчёты")
				sleep 2300
				SendChat("/me cопоставил" RP1 " данные")
				sleep 1200
				SendChat("Отсутствующие сотрудники:")
				sleep 1200
				For v, pair in ArrayNotStreamPlayer
				{
					ArrayRangsFuction(pair[2],ArrayRangs,position)
					SendChat(position " " RegExReplace(getPlayerNameById(pair[1]), "_", " ") " [Жетон №" pair[1] "]")
					sleep 1000
				}
			}
			else if ErrorLevel = EndKey:3
			{
				SendChat("/me осмотрел" RP1 " всех сотрудников и вычислил" RP1 " отсутствующих")
				sleep 2300
				SendChat("/me достал" RP1 " рацию зелёного цвета")
				sleep 2300
				SendChat("/r Отсутствующие сотрудники:")
				sleep 1000
				For v, pair in ArrayNotStreamPlayer
				{
					ArrayRangsFuction(pair[2],ArrayRangs,position)
					SendChat("/r " position " " RegExReplace(getPlayerNameById(pair[1]), "_", " ") " [Жетон №" pair[1] "]")
					sleep 500
				}
				SendChat("/r Вышеперечисленные сотрудники, ваше местоположение?")
			}
			else if ErrorLevel = EndKey:4
			{
				addChatMessageEx("CCCCCC" , "Отмена.")
			}
		}
	}
	Exit
}
;===========
;===========
;===========
if (RegExMatch(chatInput, "i)^\/sobes"))
{
	if (RegExMatch(chatInput, "i)^\/sobes (\d{1,3})", var))
	{
		id := var1
		nick := RegExReplace(getPlayerNameById(id), "_", " ")
		RegExMatch(getPlayerNameById(id), "(.*)_", value)
		name := value1
		addChatMessageEx("B8DBB8" , "Начало собеседования с {FFFFFF}" nick " [" id "]") 
		sleep 500
		SendChat("Здравствуйте. Меня зовут " RegExReplace(getUsername(), "_", " ") ".")
		sleep 1500
		SendChat("Вы попали на собеседование в Радиоцентр г.Las-Venturas.")
		sleep 1500
		goto, pass
	}
	else
		addchatmessageEx("AAAAAA" , "/sobes [id]")
}
else
;===========
;===========
;===========
if (RegExMatch(chatInput, "i)^\/gotosobes"))
{
	if (RegExMatch(chatInput, "i)^\/gotosobes (\d{1,3})", var))
	{
		id := var1
		nick := RegExReplace(getPlayerNameById(id), "_", " ")
		RegExMatch(getPlayerNameById(id), "(.*)_", value)
		name := value1
		ShowDialog(2, "{FF5F10}Переход в другой сценарий", "{FF5F10}• {FFFFFF}Попросить паспорт`n{FF5F10}• {FFFFFF}Попросить лицензии`n{FF5F10}• {FFFFFF}Попросить мед.карту`n{FF5F10}• {FFFFFF}Проверить на псих. устройчивость`n{FF5F10}• {FFFFFF}Проверить на грамотность`n{FF5F10}• {FFFFFF}Проверить на OOC термины`n{FF5F10}• {FFFFFF}Одобрить " nick " [" id "]`n{FF5F10}• {FFFFFF}Отказать в собеседовании", "Ок")
		Result := LineResult()
		if (!Result)
			return
		else if (Result = 1)
			goto, pass
		else if (Result = 2)
			goto, lic
		else if (Result = 3)
			goto, med
		else if (Result = 4)
			goto, question
		else if (Result = 5)
			goto, grammar
		else if (Result = 6)
			goto, OOCterm
		else if (Result = 7)
			goto, final
		else if (Result = 8)
			goto, AltF9
	}
	else
		addchatmessageEx("AAAAAA" , "/gotosobes [id]")
}
else
;===========
;===========
;===========
if (RegExMatch(chatInput, "i)^\/exam"))
{
	if (RegExMatch(chatInput, "i)^\/exam (\d{1,3})", var))
	{
		StateSub := 1
		id := var1
		nick := RegExReplace(getPlayerNameById(id), "_", " ")
		RegExMatch(getPlayerNameById(id), "(.*)_", value)
		name := value1
		ShowDialog(2, nick " [" id "]" , "Устав`nПРО", "Ок")
		Result := LineResult()
		if (!Result)
			return
		else if (Result = 1)
		{
			addChatMessageEx("B8DBB8" , "Приём устава у сотрудника {FFFFFF}" nick " [" id "]") 
			sleep 500
			SendChat("Итак, " RegExReplace(getPlayerNameById(id),"_", " ") ", сейчас я задам вам 3 вопроса по Уставу нашей организации.")
			sleep 2000
			goto, us1
		}
		else if (Result = 2)
		{
			addChatMessageEx("B8DBB8" , "Приём правил редактирования объявлений у сотрудника {FFFFFF}" nick " [" id "]") 
			sleep 500
			SendChat("Итак. Правила Редактирования Объявлений.")
			sleep 2000
			SendChat("Я напишу 4 различных объявления, ваша задача правильно их отредактировать.")
			sleep 2500
			SendChat("У вас есть право допустить одну ошибку.")
			sleep 2500
			goto, pro1
		}
	}
	else
		addchatmessageEx("AAAAAA" , "/exam [id]")
}
else
;===========
;===========
;===========
if (RegExMatch(chatInput, "i)^\/gotoexam"))
{
	if (RegExMatch(chatInput, "i)^\/gotoexam (\d{1,3})", var))
	{
		StateSub := 1
		id := var1
		nick := RegExReplace(getPlayerNameById(id), "_", " ")
		RegExMatch(getPlayerNameById(id), "(.*)_", value)
		name := value1
		ShowDialog(2, "{FF5F10}Переход в другой сценарий", "{FF5F10}• {FFFFFF}Устав (1 вопрос)`n{FF5F10}• {FFFFFF}Устав (2 вопрос)`n{FF5F10}• {FFFFFF}Устав (3 вопрос)`n{FF5F10}• {FFFFFF}ПРО (1 вопрос)`n{FF5F10}• {FFFFFF}ПРО (2 вопрос)`n{FF5F10}• {FFFFFF}ПРО (3 вопрос)`n{FF5F10}• {FFFFFF}ПРО (4 вопрос)", "Ок")
		Result := LineResult()
		if (!Result)
			return
		else if (Result = 1)
			goto, us1
		else if (Result = 2)
			goto, us2
		else if (Result = 3)
			goto, us3
		else if (Result = 4)
			goto, pro1
		else if (Result = 5)
			goto, pro2
		else if (Result = 6)
			goto, pro3
		else if (Result = 7)
			goto, pro4
	}
	else
		addchatmessageEx("AAAAAA" , "/gotoexam [id]")
}
;===========
;===========
;===========
}
return

JobFunction1:
SendChat("/me достал новую форму и бейджик для сотрудника " RegExReplace(getPlayerNameById(id),"_", " "))
sleep 2200
SendChat("/todo Поздравляю вас! Вы приняты. Берите форму*передав форму и бейджик")
sleep 2200
SendChat("/me достал смартфон. Открыл online-базу данных организации")
sleep 2200
SendChat("/me добавил " RegExReplace(getPlayerNameById(id),"_", " ") " в базу данных")
sleep 200
SendChat("/oldanim 6")
sleep 1800
SendChat("/invite " id)
sleep 2000
SendChat("Уважаемый сотрудник! Для того, чтобы получить повышение, необходимо будет...")
sleep 3000
SendChat("Сдать Устав СМИ и Правила Редактирования Объявлений.")
sleep 3500
SendChat("Информацию об этом вы сможете найти на портале Штата.")
sleep 2000
while isDialogOpen()
   continue
sleep 500
SendChat("/n Раздел сервера - Radiant - Государственные организации - СМИ")
sleep 3000
SendChat("/n Тема: ""Mass Media |Необходимая информация для сотрудника - СМИ.""")
sleep 3000
SendChat("Как будете готовы сдать - Просьба сообщить.")
return

JobFunction2:
showDialog("1", name " [" id "]", "{FFFFFF}Введите причину увольнения. (Без тэга и прочего)`nДля отмены оставьте поле пустым и нажмите Enter.", "Ок")
input, text, V, {Enter}
if text
{
   SendChat("/me достал смартфон. Открыл online-базу данных организации")
   sleep 2200
   SendChat("/me стёр личное дело сотрудника " RegExReplace(getPlayerNameById(id),"_", " "))
   sleep 1000
   IniRead, IniTag, settings.ini, sectionTeg, IniTag
   SendChat("/uninvite " id " " IniTag " | " text " [" id "]")
}
else Exit
return

JobFunction3:
showDialog("1", name " [" id "]", "{FFFFFF}Введите причину выговора. (Без тэга и прочего)`nДля отмены оставьте поле пустым и нажмите Enter.", "Ок")
input, text, V, {Enter}
if text
{
   sleep 200
   SendChat("/me достал смартфон. Открыл online-базу данных организации")
   sleep 2200
   SendChat("/me внёс выговор в личное дело сотрудника " RegExReplace(getPlayerNameById(id),"_", " "))
   sleep 1000
   IniRead, IniTag, settings.ini, sectionTeg, IniTag
   SendChat("/fwarn " id " " IniTag " | " text " [" id "]")
}
else Exit
return

JobFunction4:
nick := RegExReplace(getPlayerNameById(id),"_", " ")
SendChat("/me достал новый бейджик для сотрудника " nick)
sleep 2200
SendChat("/todo Поздравляю вас с повышением!*передав новый бейджик")
sleep 2200
SendChat("/me достал смартфон. Открыл online-базу данных организации")
sleep 2200
SendChat("/me внёс изменение в личное дело сотрудника " nick " в базу данных")
sleep 500
SendChat("/find")
while !(isDialogOpen() && getDialogCaption() = "{ffff00}Члены организации онлайн")
   continue
Loop
{
   if getDialogLine(A_Index+3)
   {
      if RegExMatch(getDialogLine(A_Index+3), id ".*(\d{1,2})\s+\d{1,1}/3", rang)
         break
   }
   else break
}
SendInput {enter}
while isDialogOpen()
   continue
sleep 200
if (rang1 = 1)
{
   SendChat("/rang " id)
   while !(isDialogOpen())
      continue
   SendInput, {down 1}{enter}
   while (isDialogOpen())
      continue
   sleep 200
   goto, JobFunction5
}
else
{
   SendChat("/rang " id)
   while !(isDialogOpen())
      continue
   SendInput, {down %rang1%}{enter}
   rangUp := rang1 + 1
   FileAppend, %A_DD%/%A_MM%/%A_Year%: %nick% %rang1% » %rangUp%`n, logs.txt
   while (isDialogOpen())
      continue
   addChatMessageEx("8888FF" , "[1]: {CCCCCC}Очистить личную статистику{FF7F50} (/mystats).")
   sleep 100
   addChatMessageEx("8888FF" , "[2]: {CCCCCC}Оставить всё как есть.")
   Loop
   {
      Input , OutputVar, L1 V, {1}{2}
      if (ErrorLevel = "EndKey:2")
      {
		 addChatMessageEx("CCCCCC","Completed.")
         break
	  }
	  else if (ErrorLevel = "EndKey:1")
	  {
		 SendChat("/clearfstats " nick)
         break
	  }
   }
   addChatMessageEx("8888FF" , "[1]: {CCCCCC}Выдать новую форму сотруднику.")
   sleep 100
   addChatMessageEx("8888FF" , "[2]: {CCCCCC}Оставить всё как есть.")
   Loop
   {
      Input , OutputVar, L1 V, {1}{2}
      if (ErrorLevel = "EndKey:2")
      {
		 addChatMessageEx("CCCCCC","Completed.")
         break
	  }
      else if (ErrorLevel = "EndKey:1")
         goto, JobFunction5
   }
}
return

JobFunction5:
SendChat("/me в руках пакет с новой формой")
sleep 2200
SendChat("/me передал пакет сотруднику " RegExReplace(getPlayerNameById(id),"_", " "))
sleep 1000
SendChat("/setskin " id)
return

; =================================================================
; =================================================================
; Role Play Sobes [start of code]
; =================================================================
; =================================================================

pass:
SendChat("Покажите пожалуйста ваш паспорт.")
sleep 1000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenSobes)
Loop
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
		goto, lic
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9
}
return

lic:
SendChat("Хорошо. Продолжим собеседование. Теперь мне нужны ваши лицензии.")
sleep 1000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenSobes)
Loop
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
		goto, med
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9
}
return

med:
SendChat("Медицинскую карту.")
sleep 1000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenSobes)
Loop
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
		goto, goQuestion
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9
}
return

goQuestion:
{
	SendChat("Замечательно. С документами у вас всё в порядке.")
	sleep 3000
	SendChat("Теперь я проведу проверку на псих. устройчивость и грамотность.")
	sleep 1500
	goto, question
}
return

question:
Array := ["/N Покажите ещё раз свой паспорт, пожалуйста." 
		 ,"Разрешено ли у нас в организации МГ? Если нет, то объясните, почему."
		 ,"У вас довольно неплохой ник{!} Были ли у вас раньше какие-то другие ники?"
		 ,"У вас есть скиллы? Покажите, если есть."
		 ,"Умирали ли вы когда-нибудь? Сколько раз примерно?"]
Random, k, 1, % Array.MaxIndex()
pm := Array[k]
SendMessage, 0x50,, 0x4190419,, A
SendInput {F6}%pm%{space}
sleep 3000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , "[Alt + 1]: {CCCCCC}Перейти к вопросу о грамотности.")
sleep 50
addChatMessageEx("FF7F50" , "[Alt + 2]: {CCCCCC}Задать ещё вопрос на псих. устройчивость.")
sleep 50
addChatMessageEx("FF7F50" , "[Alt + 3]: {CCCCCC}Перейти к OOC проверке Role-Play терминов.")
sleep 50
addChatMessageEx("FF7F50" , "[Alt + 9]: {CCCCCC}Отказать в собеседовании. {FF7F50}[Alt+F12]: {CCCCCC}Остановить скрипт.")
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
		goto, grammar
	else if (GetKeyState("Alt", "P") && GetKeyState("2", "P"))
		goto, question
	else if (GetKeyState("Alt", "P") && GetKeyState("3", "P"))
		goto, OOCterm
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9
}
return

grammar:
SendChat("/do На столе лежат листок и ручка.")
sleep 3500
SendChat("/todo " name ", держите ручку.*передавая ручку " nick)
sleep 3500
SendChat("/do На листке написано: " NotRigthWord())
sleep 3500
SendChat("Итак. Ваша задача исправить орфографические ошибки в фразе на листке, если они есть.")
sleep 1000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , "[Alt + 1]: {CCCCCC}Перейти к OOC проверке Role-Play терминов.")
sleep 50
addChatMessageEx("FF7F50" , "[Alt + 2]: {CCCCCC}Задать ещё вопрос на грамотность.")
sleep 50
addChatMessageEx("FF7F50" , "[Alt + 3]: {CCCCCC}Задать ещё вопрос на псих. устройчивость.")
sleep 50
addChatMessageEx("FF7F50" , "[Alt + 9]: {CCCCCC}Отказать в собеседовании. {FF7F50}[Alt+F12]: {CCCCCC}Остановить скрипт.")
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
		goto, OOCterm
	else if (GetKeyState("Alt", "P") && GetKeyState("2", "P"))
		goto, grammar
	else if (GetKeyState("Alt", "P") && GetKeyState("3", "P"))
		goto, question
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9
}
return
	
NotRigthWord()
{
	Array := ["праходит нобор транпартную кампанию."
			 ,"куплю прибельное придприятее."
			 ,"праходит нобор в таксапарк."
			 ,"бютжед: 50 тысечь."
			 ,"нуждаюсь в прафесиональном адвакате."
			 ,"кросивые акссэсуары."
			 ,"карпарация абщественого инфармиравания."
			 ,"красивий оэрапорт."
			 ,"опастный раён."
			 ,"грамматний сатрудник."]
	Random, k, 1, % Array.MaxIndex()
	return % Array[k]
}

OOCterm:
SendChat("/n Теперь проведём OOC проверку на знание Role-Play терминов.")
sleep 2000
SendChat("/stats")
while !(isDialogOpen() && getDialogCaption() = "{cc9900}Статистика")
	continue
RegExMatch(getDialogLine(7) , "{FFFFFF}Номер телефона:\s+{0099ff}(.*)", numb)
number := RegExReplace(numb1, "(\d)(\d)(\d)(\d)(\d)(\d)", "$1$2-$3$4-$5$6")
SendInput {enter}
while isDialogOpen()
   continue
SendChat("/n Ваша задача написать обозначение терминов " RandomOOCterms() " в SMS на номер: " number)
sleep 1000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , "[Alt + 1]: {CCCCCC}Одобрить человека. {FF7F50}[Alt + 9]: {CCCCCC}Отказать в собеседовании. {FF7F50}[F12]: {CCCCCC}Перезагрузить скрипт.")
Loop	
{
if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	goto, final
else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
	goto, AltF9
}
return

RandomOOCterms()
{
	Array := ["MG, SK"
			 ,"RP, MG"
			 ,"TK, PG"
			 ,"SK, PG"]
	Random, k, 1, % Array.MaxIndex()
	return % Array[k]
}

final:
{
	SendChat(nick ", поздравляю вас, вы нам подходите!")
	sleep 2200
	SendChat("Сейчас вам выдадут форму. Переодевайтесь и можете приступать к работе.")
	sleep 2200
	SendChat("/n Для того, чтобы начать редактировать объявления, нужно достигнуть 2 ранга.")
	sleep 2200
	SendChat("/n А для этого достаточно сдать Устав и ПРО. (Всё это можно найти на форуме)")
	sleep 2000
	addChatMessageEx("B8DBB8" , "Cобеседование с {FFFFFF}" nick " [" id "]{B8DBB8} завершено.")
	sleep 100
	addChatMessageEx("B8DBB8" , "[AHK]: Cкрипт был перезагружен.")
	Reload
}
return

AltF9:
SendChat("Извините " nick ", но вы нам не подходите. Всего доброго!")
sleep 500
addChatMessageEx("B8DBB8" , "Cобеседование с {FFFFFF}" nick " [" id "]{B8DBB8} завершено.")
sleep 100
addChatMessageEx("B8DBB8" , "[AHK]: Cкрипт был перезагружен.")
Reload
return

us1:
SendChat("Первый вопрос.")
sleep 1500
Array := ["Рабочее время по будням?"
		 ,"Рабочее время по выходным?"
		 ,"Когда у нас перерыв?"]
Random, k, 1, % Array.MaxIndex()
SendChat(Array[k])
sleep 2000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenJob)  
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		SendChat("Правильно!")
		sleep 2000
		goto, us2
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9_2
}
return

us2:
SendChat("Второй вопрос.")
sleep 1500
Array := ["С какой должности разрешены переводы из отдела в отдел?"
		 ,"С какой должности можно говорить на волне всех радиоцентров?"
		 ,"C какой должности можно уходить в отпуск?"]
Random, k, 1, % Array.MaxIndex()
SendChat(Array[k])
sleep 2000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenJob)  
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		SendChat("Верно!")
		sleep 2000
		goto, us3
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9_2
}
return

us3:
SendChat("Третий вопрос.")
sleep 1500
Array := ["С какой должности можно брать фургон?"
		 ,"С какой должности можно брать вертолет?"
		 ,"С какой должности можно посещать мероприятия в рабочее время?"]
Random, k, 1, % Array.MaxIndex()
SendChat(Array[k])
sleep 2000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenJob)  
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
		goto, goPro
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
		goto, AltF9_2
}
return

goPro:
SendChat("Поздравляю " name "! Вы сдали Устав.")
sleep 1000
addChatMessageEx("FF7F50" , "[Alt + 1]: {CCCCCC}Начать проверку ПРО. {FF7F50}[Alt + 2]: {CCCCCC}Закончить экзамен. {FF7F50}[F12]: {CCCCCC}Перезагрузить скрипт.")
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		SendChat("Переходим к Правилам Редактирования Объявлений.")
		sleep 2500
		SendChat("Я напишу 4 различных объявления, ваша задача правильно их отредактировать.")
		sleep 2500
		SendChat("У вас есть право допустить одну ошибку.")
		sleep 2500
		goto, pro1
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("2", "P"))
	{
		addChatMessageEx("B8DBB8" , "Экзамен с {FFFFFF}" nick " [" id "]{B8DBB8} завершён.")
		sleep 100
		addChatMessageEx("B8DBB8" , "[AHK]: Cкрипт был перезагружен.")
		Reload
	}
}
return

pro1:
SendChat("/me достал листок и ручку, после чего написал на листке объявление")
sleep 2200
Array := ["Куплю машину фулл пт."
		 ,"Продам турик за 1.8кк ФТ."
		 ,"Продам верт Maverick за 7.4кк."]
Random, k, 1, % Array.MaxIndex()
SendChat("/do На листке написано: " Array[k])
sleep 1500
SendChat("Напишите на листочке отредактированное объявление.")
sleep 2000
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenJob)  
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		SendChat("Верно.")
		sleep 2500
		goto, pro2
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
	{
		NextMet := 2
		goto, RightOfError
	}
}
return

pro2:
SendChat("/me написал на листочке ещё одно объявление")
sleep 2200
Array := ["Продам дом за 400к."
		 ,"Куплю средняк в сф."
		 ,"Продам номер в отеле Централ ЛС."]
Random, k, 1, % Array.MaxIndex()
SendChat("/do На листке написано: " Array[k])
sleep 1500
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenJob)  
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		SendChat("Правильно.")
		sleep 2500
		goto, pro3
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
	{
		NextMet := 3
		goto, RightOfError
	}
}
return

pro3:
SendChat("/me написал на листочке ещё одно объявление")
sleep 2200
Array := ["Ищу друзей с майкой скайп."
		 ,"Продам макет оружия AK-47."
		 ,"Проходит набор в мексику."]
Random, k, 1, % Array.MaxIndex()
SendChat("/do На листке написано: " Array[k])
sleep 1500
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenJob) 
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		SendChat("Правильно.")
		sleep 2500
		goto, pro4
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
	{
		NextMet := 4
		goto, RightOfError
	}
}
return

pro4:
SendChat("/me написал на листочке ещё одно объявление")
sleep 2200
Array := ["Продам симку 77-66-55."
		 ,"Куплю красивую симку формата AA-BB-CC."]
Random, k, 1, % Array.MaxIndex()
SendChat("/do На листке написано: " Array[k])
sleep 1500
addChatMessageEx("B8DBB8", Helper) 
Keywait, F11 , D
addChatMessageEx("FF7F50" , goThenJob) 
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		SendChat("Поздравляю " name "! Вы сдали Правила Редактирования Объявлений.")
		sleep 1000
		goto, goUs
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("9", "P"))
	{
		if (StateSub = 1)
		{
			SendChat("Ответ неправильный.")
			sleep 1500
			SendChat("Но экзамен вы сдали, т.к ответили верно на предыдущие вопросы.")
			StateJob = 0
			sleep 1000
			goto, goUs
		}
		else if (StateSub = 0)
			goto, AltF9_2
	}
}
return

goUs:
addChatMessageEx("FF7F50" , "[Alt + 1]: {CCCCCC}Закончить экзамен. {FF7F50}[Alt + 2]: {CCCCCC}Начать проверку Устава. {FF7F50}[F12]: {CCCCCC}Перезагрузить скрипт.")
Loop	
{
	if (GetKeyState("Alt", "P") && GetKeyState("1", "P"))
	{
		addChatMessageEx("B8DBB8" , "Экзамен с {FFFFFF}" nick " [" id "]{B8DBB8} завершён.")
		sleep 100
		addChatMessageEx("B8DBB8" , "[AHK]: Cкрипт был перезагружен.")
		Reload
	}
	else if (GetKeyState("Alt", "P") && GetKeyState("2", "P"))
	{
		SendChat("Переходим к Уставу.")
		sleep 1500
		SendChat("Всего будет 3 вопроса без права на ошибку.")
		sleep 1500
		goto, us1
	}
}
return

AltF9_2:
SendChat("Ответ неправильный.")
sleep 1500
SendChat(name ", к сожалению вы не сдали экзамен. Приходите на пересдачу.")
sleep 300
addChatMessageEx("B8DBB8" , "Экзамен с {FFFFFF}" nick " [" id "]{B8DBB8} завершён.")
sleep 100
addChatMessageEx("B8DBB8" , "[AHK]: Cкрипт был перезагружен.")
Reload
return

RightOfError:
if (StateSub = 1)
{
	StateSub := 0
	SendChat("Ответ неправильный. Теперь у вас нет права на ошибку.")
	sleep 1500
	SendChat("Идём далее.")
	sleep 1500
	goto, pro%NextMet%
	sleep 1500
}
else if (StateSub = 0)
	goto, AltF9_2
return

; =================================================================
; =================================================================
; Role Play Sobes [end of code]
; =================================================================
; =================================================================

ArrayToSendChat(sleepTime,Array)
{
    Loop % Array.MaxIndex()-1 
    {
        SendChat(Array[A_Index])
        sleep % sleepTime
    }
    SendChat(Array[Array.MaxIndex()])
}

Town()
{
    IniRead, IniTag, settings.ini, sectionTeg, IniTag
    if IniTag = LS
        return "Los-Santos"
    else if IniTag = SF
        return "San-Fierro"
    else if IniTag = LV
        return "Las-Venturas"
    else
        return "Mass-Media"
}

ArrayOutputForCfind(Array,step)
{
	stepLoop := 0
	lengArray := Array.MaxIndex()
    Loop 
    {
        if lengArray > %step%
        {
            Loop % step
            {
                id := Array[A_Index + stepLoop][1]
                outputlist .= getPlayerNameById(id) " [" id "]. "
            }
            lengArray := lengArray - step
            addchatmessageEx("B8DBB8" , outputlist)
            outputlist := ""
        }
        else 
        {
            Loop % lengArray
            {
                id := Array[A_Index + stepLoop][1]
                outputlist .= getPlayerNameById(id) " [" id "]. "
            }
            addchatmessageEx("B8DBB8" , outputlist)
            outputlist := ""
            break
        }
        stepLoop := stepLoop + step
    }
}

ArrayRangsFuction(rang , ArrayRangs , ByRef position)
{
    For n, position in ArrayRangs
    {
        if rang = %n%
        {
            position := ArrayRangs[A_Index]
            break
        }
    }
}

SexPerson()
{
    if (getsexbyskin(getPlayerSkinId()) = 2)
    {
        global RP1 := "а"
        global RP2 := "зашла"
        global RP3 := "внесла"
        global RP4 := "ась"
        global RP5 := "вышла"
        global RP6 := "отошла"
        global RP7 := "подошла"
        global RP8 := "перешла"
    } 
    else  
    {
        global RP1 := ""
        global RP2 := "зашел"
        global RP3 := "внес"
        global RP4 := "ся"
        global RP5 := "вышел"
        global RP6 := "отошёл"
        global RP7 := "подошёл"
        global RP8 := "перешёл"
    }
}

LineResult() 
{
    if (!isDialogOpen() || getDialogStyle() = 0 || getDialogStyle() = 1 || getDialogStyle() = 3)
        return false
    while (isDialogOpen())
        continue
    if (GetKeyState("Esc", "P"))
        return false
    return getDialogLineNumber()
}

F11::
addchatmessage("обновка")
return