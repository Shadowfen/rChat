--[[
Author: Ayantir
Filename: es.lua
Version: 5

Many Thanks to Toperharrier for his original work

]]--

-- Vars with -H are headers, -TT are tooltips
-- All the texts that need a translation. As this is being used as the
-- default (fallback) language, all strings that the addon uses MUST
-- be defined here.

--base language is english, so the file en.lua shuld be kept empty!
rChat_localization_strings = rChat_localization_strings  or {}

rChat_localization_strings["es"] = {

	-- ************************************************
	-- Chat tab selector Bindings
	-- ************************************************
	RCHAT_Tab1 = "Select Chat Tab 1",
	RCHAT_Tab2 = "Select Chat Tab 2",
	RCHAT_Tab3 = "Select Chat Tab 3",
	RCHAT_Tab4 = "Select Chat Tab 4",
	RCHAT_Tab5 = "Select Chat Tab 5",
	RCHAT_Tab6 = "Select Chat Tab 6",
	RCHAT_Tab7 = "Select Chat Tab 7",
	RCHAT_Tab8 = "Select Chat Tab 8",
	RCHAT_Tab9 = "Select Chat Tab 9",
	RCHAT_Tab10 = "Select Chat Tab 10",
	RCHAT_Tab11 = "Select Chat Tab 11",
	RCHAT_Tab12 = "Select Chat Tab 12",
    
	-- 9.3.6.24 Additions
	RCHAT_CHATTABH = "Chat Tab Settings",
	RCHAT_enableChatTabChannel = "Enable Last Used Channel Per Tab",
	RCHAT_enableChatTabChannelT = "Enable chat tabs to remember the last used channel, it will become the default until you opt to use a different one in that tab.",
	RCHAT_enableWhisperTab = "Enable Whisper Redirect",
	RCHAT_enableWhisperTabT = "Enable redirect your whispers to a specific tab.",
	
-- New Need Translations
	RCHAT_OPTIONSH = "Opciones",

	RCHAT_GUILDNUMBERS = "Numerar gremios",
	RCHAT_GUILDNUMBERSTT = "Muestra el número de gremio al lado de su etiqueta",

	RCHAT_ALLGUILDSSAMECOLOUR = "Usar el mismo color para todos los gremios",
	RCHAT_ALLGUILDSSAMECOLOURTT = "Colorea todos los gremios del mismo color que /guild1",

	RCHAT_ALLZONESSAMECOLOUR = "Usar el mismo color para todos los chat de zona",
	RCHAT_ALLZONESSAMECOLOURTT = "Colorea todos los chats de zona del mismo color que /zone",

	RCHAT_ALLNPCSAMECOLOUR = "Usar el mismo color para todas las lineas de PNJ",
	RCHAT_ALLNPCSAMECOLOURTT = "Hace que todo el texto de PNJs use el mismo color que PNJ /say",

	RCHAT_DELZONETAGS = "Desactiva las etiquetas de zona",
	RCHAT_DELZONETAGSTT = "Borra las etiquetas del tipo dice, grita al inicio del mensaje de chat",

	RCHAT_ZONETAGSAY = "dice",
	RCHAT_ZONETAGYELL = "grita",
	RCHAT_ZONETAGPARTY = "Grupo",
	RCHAT_ZONETAGZONE = "zona",

	RCHAT_CARRIAGERETURN = "Newline between name and message",
	RCHAT_CARRIAGERETURNTT = "Player names and chat texts are separated by a newline.",

	RCHAT_USEESOCOLORS = "Usar colores de ESO",
	RCHAT_USEESOCOLORSTT = "Usa los colores seleccionados en las opciones sociales del juego en lugar de las de rChat",

	RCHAT_DIFFFORESOCOLORS = "Diferencia entre los colores de ESO",
	RCHAT_DIFFFORESOCOLORSTT = "Si usas los colores de ESO y la opción dos colores de rChat, puedes ajustar la diferencia de brillo entre el nombre de jugador y el mensaje",

	RCHAT_REMOVECOLORSFROMMESSAGES = "Eliminar mensajes coloreados",
	RCHAT_REMOVECOLORSFROMMESSAGESTT = "Evita gente utilizando cosas como el texto de chat coloreado tipo arco-iris",

	RCHAT_PREVENTCHATTEXTFADING = "Desactivar el desvanecimiento de texto del chat",
	RCHAT_PREVENTCHATTEXTFADINGTT = "Evita que el texto del chat desaparezca(puedes ajustar la transparencia de fondo bajo Opciones - Social)",

	RCHAT_AUGMENTHISTORYBUFFER = "Augment # of lines displayed in chat",
	RCHAT_AUGMENTHISTORYBUFFERTT = "Per default, only the last 200 lines are displayed in chat. This feature raise this value up to 1000 lines",

	RCHAT_USEONECOLORFORLINES = "Usar un solo color",
	RCHAT_USEONECOLORFORLINESTT = "En lugar de usar dos colores por canal, usa solo el primer color",

	RCHAT_GUILDTAGSNEXTTOENTRYBOX = "Etiquetas de gremio en el cajón de escritura del chat",
	RCHAT_GUILDTAGSNEXTTOENTRYBOXTT = "Muestra la etiqueta del gremio en lugar del nombre en el cajón de escritura del chat",

	RCHAT_DISABLEBRACKETS = "Eliminar los corchetes de los nombres",
	RCHAT_DISABLEBRACKETSTT = "Elimina los corchetes [] que rodean los nombres de jugadores",

	RCHAT_DEFAULTCHANNEL = "Chat predeterminado",
	RCHAT_DEFAULTCHANNELTT = "Selecciona el chat a usar al iniciar sesión",

	RCHAT_DEFAULTCHANNELCHOICE99 = "Do not change",
	RCHAT_DEFAULTCHANNELCHOICE31 = "/zone",
	RCHAT_DEFAULTCHANNELCHOICE0 = "/say",
	RCHAT_DEFAULTCHANNELCHOICE12 = "/guild1",
	RCHAT_DEFAULTCHANNELCHOICE13 = "/guild2",
	RCHAT_DEFAULTCHANNELCHOICE14 = "/guild3",
	RCHAT_DEFAULTCHANNELCHOICE15 = "/guild4",
	RCHAT_DEFAULTCHANNELCHOICE16 = "/guild5",
	RCHAT_DEFAULTCHANNELCHOICE17 = "/officer1",
	RCHAT_DEFAULTCHANNELCHOICE18 = "/officer2",
	RCHAT_DEFAULTCHANNELCHOICE19 = "/officer3",
	RCHAT_DEFAULTCHANNELCHOICE20 = "/officer4",
	RCHAT_DEFAULTCHANNELCHOICE21 = "/officer5",

	RCHAT_GEOCHANNELSFORMAT = "Names format",
	RCHAT_GEOCHANNELSFORMATTT = "Names format for local channels (say, zone, tell)",

	RCHAT_DEFAULTTAB = "Default tab",
	RCHAT_DEFAULTTABTT = "Select which tab to display at startup",

	RCHAT_ADDCHANNELANDTARGETTOHISTORY = "Switch channel when using history",
	RCHAT_ADDCHANNELANDTARGETTOHISTORYTT = "Switch the channel when using arrow keys to match the channel previously used.",

	RCHAT_URLHANDLING = "Detect and make URLs linkable",
	RCHAT_URLHANDLINGTT = "If a URL starting with http(s):// is linked in chat pChat will detect it and you'll be able to click on it to directly go on the concerned link with your system browser",

	RCHAT_ENABLECOPY = "Activar copia",
	RCHAT_ENABLECOPYTT = "Activar copia con un clic derecho sobre el texto - también activar el conmutador de canal con un clic izquierdo. Desactive esta opción si tienes problemas para visualizar los enlaces en el chat",


	-- Group Settings

	RCHAT_GROUPH = "Party channel tweaks",

	RCHAT_ENABLEPARTYSWITCH = "Habilitar cambio automático al entrar en grupo",
	RCHAT_ENABLEPARTYSWITCHTT = "Habilitar el cambio automático cambiara tu canal de chat actual al canal de grupo al entrar en uno y lo restaurará al salir de el",

	RCHAT_GROUPLEADER = "Special color for party leader",
	RCHAT_GROUPLEADERTT = "Enabling this feature will let you set a special color for party leader messages",

	RCHAT_GROUPLEADERCOLOR = "Party leader color",
	RCHAT_GROUPLEADERCOLORTT = "Color of party leader messages. 2nd color is only to set if \"Use ESO colors\" is set to Off",

	RCHAT_GROUPLEADERCOLOR1 = "Color of messages for party leader",
	RCHAT_GROUPLEADERCOLOR1TT = "Color of message for party leader. If \"Use ESO colors\" is set to Off, this option will be disabled. The color of the party leader will be the one set above and the party leader messages will be this one",

	RCHAT_GROUPNAMES = "Names format for groups",
	RCHAT_GROUPNAMESTT = "Format of your groupmates names in party channel",

	RCHAT_GROUPNAMESCHOICE1 = "@UserID",
	RCHAT_GROUPNAMESCHOICE2 = "Character Name",
	RCHAT_GROUPNAMESCHOICE3 = "Character Name@UserID",

	-- Sync settings

	RCHAT_SYNCH = "Syncing settings",

	RCHAT_CHATSYNCCONFIG = "Sincronizar la configuración del chat",
	RCHAT_CHATSYNCCONFIGTT = "Si la sincronización está habilitada, todos tus personajes tendrán la misma configuración del chat (color, orientación, tamaño de la ventana, pestañas) \ nPS: Seleccione esta opción cuando su chat configurado correctamente!",

	RCHAT_CHATSYNCCONFIGIMPORTFROM = "Importar configuración del chat",
	RCHAT_CHATSYNCCONFIGIMPORTFROMTT = "Siempre se puede importar la configuración del chat instantánea de otro personaje (color, orientación, tamaño de la ventana, pestañas)",

	-- Apparence

	RCHAT_APPARENCEMH = "Chat window settings",

	RCHAT_WINDOWDARKNESS = "Chat window transparency",
	RCHAT_WINDOWDARKNESSTT = "Increase the darkening of the chat window",

	RCHAT_CHATMINIMIZEDATLAUNCH = "Chat es minimizado en el arranque",
	RCHAT_CHATMINIMIZEDATLAUNCHTT = "Minimizar la ventana de chat de la izquierda en el lanzamiento",

	RCHAT_CHATMINIMIZEDINMENUS = "Chat es minimizado en menús",
	RCHAT_CHATMINIMIZEDINMENUSTT = "Minimizar ventana de chat a la izquierda de la pantalla cuando usted entra en los menús (Gremio, Personaje, la artesanía, etc.)",

	RCHAT_CHATMAXIMIZEDAFTERMENUS = "Restaurar chat después de salir de los menús",
	RCHAT_CHATMAXIMIZEDAFTERMENUSTT = "Siempre restaurar la ventana de chat después de salir de los menús",

	RCHAT_FONTCHANGE = "Fuente del texto",
	RCHAT_FONTCHANGETT = "Establecer la fuente del texto",

	RCHAT_TABWARNING = "Alerta de mensaje nuevo",
	RCHAT_TABWARNINGTT = "Establece el color de alerta para pestañas del chat",

	-- Whisper settings

	RCHAT_IMH = "Susurros",

	RCHAT_SOUNDFORINCWHISPS = "Sonido para susurros entrantes",
	RCHAT_SOUNDFORINCWHISPSTT = "Elige un sonido a reproducir cuando recibas un susurro",

	RCHAT_NOTIFYIM = "Visual notification",
	RCHAT_NOTIFYIMTT = "If you miss a whisp, a notification will appear in the top right corner of the chat allowing you to quickly access to it. Plus, if your chat was minimized at that time, a notification will be displayed in the minibar",

	RCHAT_SOUNDFORINCWHISPSCHOICE1 = "Ninguno",
	RCHAT_SOUNDFORINCWHISPSCHOICE2 = "Notificación",
	RCHAT_SOUNDFORINCWHISPSCHOICE3 = "Clic",
	RCHAT_SOUNDFORINCWHISPSCHOICE4 = "Escritura",

	-- Restore chat settings

	RCHAT_RESTORECHATH = "Restore chat",

	RCHAT_RESTOREONRELOADUI = "After a ReloadUI",
	RCHAT_RESTOREONRELOADUITT = "After reloading game with a ReloadUI(), pChat will restore your chat and its history",

	RCHAT_RESTOREONLOGOUT = "After a LogOut",
	RCHAT_RESTOREONLOGOUTTT = "After a logoff, pChat will restore your chat and its history if you login in the allotted time set under",

	RCHAT_RESTOREONAFK = "After being kicked",
	RCHAT_RESTOREONAFKTT = "After being kicked from game after inactivity, flood or a network disconnect, pChat will restore your chat and its history if you login in the allotted time set under",

	RCHAT_RESTOREONQUIT = "After leaving game",
	RCHAT_RESTOREONQUITTT = "After leaving game, pChat will restore your chat and its history if you login in the allotted time set under",

	RCHAT_TIMEBEFORERESTORE = "Maximum time for restoring chat",
	RCHAT_TIMEBEFORERESTORETT = "After this time (in hours), pChat will not attempt to restore the chat",

	RCHAT_RESTORESYSTEM = "Restore System Messages",
	RCHAT_RESTORESYSTEMTT = "Restore System Messages (Such as login notifications or add ons messages) when chat is restored",

	RCHAT_RESTORESYSTEMONLY = "Restore Only System messages",
	RCHAT_RESTORESYSTEMONLYTT = "Restore Only System Messages (Such as login notifications or add ons messages) when chat is restored",

	RCHAT_RESTOREWHISPS = "Restore Whispers",
	RCHAT_RESTOREWHISPSTT = "Restore whispers sent and received after logoff, disconnect or quit. Whispers are always restored after a ReloadUI()",

	RCHAT_RESTORETEXTENTRYHISTORYATLOGOUTQUIT  = "Restore Text entry history",
	RCHAT_RESTORETEXTENTRYHISTORYATLOGOUTQUITTT  = "Restore Text entry history available with arrow keys after logoff, disconnect or quit. History of text entry is always restored after a ReloadUI()",

	-- Anti Spam settings

	RCHAT_ANTISPAMH = "Anti-Spam",

	RCHAT_FLOODPROTECT = "Activar anti-flood",
	RCHAT_FLOODPROTECTTT = "Evita que los jugadores cerca de usted y no podrá enviar mensajes idénticos repetidos",

	RCHAT_FLOODGRACEPERIOD = "Duración de destierro anti-flood",
	RCHAT_FLOODGRACEPERIODTT = "Número de segundos mientras se ignorará el mensaje idéntico anterior",

	RCHAT_LOOKINGFORPROTECT = "No haga caso de mensajes de agrupación",
	RCHAT_LOOKINGFORPROTECTTT = "No haga caso de los mensajes de los jugadores que buscan establecer / unirse a grupo",

	RCHAT_WANTTOPROTECT = "No haga caso de mensajes comerciales",
	RCHAT_WANTTOPROTECTTT = "No haga caso de los mensajes de los jugadores que buscan comprar, venta o canje",

	RCHAT_SPAMGRACEPERIOD = "Detener temporalmente el correo no deseado",
	RCHAT_SPAMGRACEPERIODTT = "Cuando te haces un mensaje de grupo de investigación, o el comercio, el spam desactiva temporalmente la función que ha anulado el tiempo para tener una respuesta. Se reactiva automáticamente después de un período que se puede conectar (en minutos)",

	-- Nicknames settings

	RCHAT_NICKNAMESH = "Nicknames",
	RCHAT_NICKNAMESD = "You can add nicknames for the people you want, just type OldName = Newname\n\nE.g : @Ayantir = Little Blonde\nIt will change the name of all the account if OldName is a @UserID or only the specified Char if the OldName is a Character Name.",
	RCHAT_NICKNAMES = "List of Nicknames",
	RCHAT_NICKNAMESTT = "You can add nicknames for the people you want, just type OldName = Newname\n\nE.g : @Ayantir = Little Blonde\n\nIt will change the name of all the account if OldName is a @UserID or only the specified Char if the OldName is a Character Name.",

	-- Timestamp settings

	RCHAT_TIMESTAMPH = "Etiqueta horaria",

	RCHAT_ENABLETIMESTAMP = "Activar etiquetas horarias",
	RCHAT_ENABLETIMESTAMPTT = "Añade una etiqueta horaria a los mensajes de texto",

	RCHAT_TIMESTAMPCOLORISLCOL = "Colorear la etiqueta horaria de igual forma que el interlocutor",
	RCHAT_TIMESTAMPCOLORISLCOLTT = "Ignora el color de la etiqueta horaria y la colorea igual al nombre del jugador o PNJ interlocutor",

	RCHAT_TIMESTAMPFORMAT = "Formato de etiqueta horaria",
	RCHAT_TIMESTAMPFORMATTT = "FORMAT:\nHH: horas (24)\nhh: horas (12)\nH: hora (24, sin 0 de inicio)\nh: hora (12, sin 0 de inicio)\nA: AM/PM\na: am/pm\nm: minutos\ns: segundos",

	RCHAT_TIMESTAMP = "Etiqueta horaria",
	RCHAT_TIMESTAMPTT = "Establece el color para la etiqueta horaria",

	-- Guild settings

	RCHAT_NICKNAMEFOR = "Nombre",
	RCHAT_NICKNAMEFORTT = "Nombre para ",

	RCHAT_OFFICERTAG = "Etiqueta de canal de Oficial",
	RCHAT_OFFICERTAGTT = "Prefijo para canales de Oficiales",

	RCHAT_SWITCHFOR = "Switch for channel",
	RCHAT_SWITCHFORTT = "New switch for channel. Ex: /myguild",

	RCHAT_OFFICERSWITCHFOR = "Switch for officer channel",
	RCHAT_OFFICERSWITCHFORTT = "New switch for officer channel. Ex: /offs",

	RCHAT_NAMEFORMAT = "Formato de nombre",
	RCHAT_NAMEFORMATTT = "Selecciona como son presentados los nombres de miembros del gremio",

	RCHAT_FORMATCHOICE1 = "@IDUsuario",
	RCHAT_FORMATCHOICE2 = "Nombre del personaje",
	RCHAT_FORMATCHOICE3 = "Nombre del personaje@IDUsuario",

	RCHAT_SETCOLORSFORTT = "Establecer colores para miembros de <<1>>",
	RCHAT_SETCOLORSFORCHATTT = "Establecer colores para mensajes de <<1>>",

	RCHAT_SETCOLORSFOROFFICIERSTT = "Establecer colores para miembro del chat de Oficiales de <<1>>",
	RCHAT_SETCOLORSFOROFFICIERSCHATTT = "Establecer colores para mensajes del chat de Oficiales de <<1>>",

	RCHAT_MEMBERS = "<<1>> - Jugadores",
	RCHAT_CHAT = "<<1>> - Mensajes",

	RCHAT_OFFICERSTT = " Oficiales",

	-- Channel colors settings

	RCHAT_CHATCOLORSH = "Colores del chat",

	RCHAT_SAY = "Dice - Jugador",
	RCHAT_SAYTT = "Establece el color para el nombre del jugador en el canal principal",

	RCHAT_SAYCHAT = "Dice - Chat",
	RCHAT_SAYCHATTT = "Establece el color del mensaje de chat para el canal principal",

	RCHAT_ZONE = "Zona - Jugador",
	RCHAT_ZONETT = "Establece el color para el nombre del jugador en el canal de zona",

	RCHAT_ZONECHAT = "Zona - Chat",
	RCHAT_ZONECHATTT = "Establece el color del mensaje de chat para el canal de zona",

	RCHAT_YELL = "Grito - Jugador",
	RCHAT_YELLTT = "Establece el color para el nombre del jugador en el canal de gritos",

	RCHAT_YELLCHAT = "Grito - Chat",
	RCHAT_YELLCHATTT = "Establece el color del mensaje de chat para el canal de gritos",

	RCHAT_INCOMINGWHISPERS = "Susurros entrantes - Jugador",
	RCHAT_INCOMINGWHISPERSTT = "Establece el color para el nombre del jugador en susurros entrantes",

	RCHAT_INCOMINGWHISPERSCHAT = "Susurros entrantes - Chat",
	RCHAT_INCOMINGWHISPERSCHATTT = "Establece el color del mensaje de chat para susurros entrantes",

	RCHAT_OUTGOINGWHISPERS = "Susurros salientes - Jugador",
	RCHAT_OUTGOINGWHISPERSTT = "Establece el color para el nombre del jugador en susurros salientes",

	RCHAT_OUTGOINGWHISPERSCHAT = "Susurros salientes - Chat",
	RCHAT_OUTGOINGWHISPERSCHATTT = "Establece el color del mensaje de chat para susurros salientes",

	RCHAT_GROUP = "Grupo - Jugador",
	RCHAT_GROUPTT = "Establece el color para el nombre del jugador en el canal de grupo",

	RCHAT_GROURCHAT = "Grupo - Chat",
	RCHAT_GROURCHATTT = "Establece el color del mensaje de chat para grupos",

	-- Other colors

	RCHAT_OTHERCOLORSH = "Otros colores",

	RCHAT_EMOTES = "Emoticones - Jugador",
	RCHAT_EMOTESTT = "Establece el color para el jugador en emoticones",

	RCHAT_EMOTESCHAT = "Emoticones - Chat",
	RCHAT_EMOTESCHATTT = "Establece el color de texto de los emoticones",

	RCHAT_ENZONE = "EN Zona - Jugador",
	RCHAT_ENZONETT = "Establece el color para el jugador en el canal de zona ingles",

	RCHAT_ENZONECHAT = "EN Zona - Chat",
	RCHAT_ENZONECHATTT = "Establece el color de chat para el canal de zona ingles",

	RCHAT_FRZONE = "FR Zona - Jugador",
	RCHAT_FRZONETT = "Establece el color para el jugador en el canal de zona francés",

	RCHAT_FRZONECHAT = "FR Zona - Chat",
	RCHAT_FRZONECHATTT = "Establece el color de chat para el canal de zona francés",

	RCHAT_DEZONE = "DE Zona - Jugador",
	RCHAT_DEZONETT = "Establece el color para el jugador en el canal de zona alemán",

	RCHAT_DEZONECHAT = "DE Zona - Chat",
	RCHAT_DEZONECHATTT = "Establece el color de chat para el canal de zona alemán",

	RCHAT_JPZONE = "JP Zone - Player",
	RCHAT_JPZONETT = "Set player color for Japanese zone channel",

	RCHAT_JPZONECHAT = "JP Zone - Chat",
	RCHAT_JPZONECHATTT = "Set chat color for Japanese zone channel",

	RCHAT_NPCSAY = "PNJ Decir - Nombre PNJ",
	RCHAT_NPCSAYTT = "Establece el color para el nombre de PNJ",

	RCHAT_NPCSAYCHAT = "PNJ Decir - Chat",
	RCHAT_NPCSAYCHATTT = "Establece el color para el mensaje de PNJs",

	RCHAT_NPCYELL = "PNJ Gritos - Nombre PNJ",
	RCHAT_NPCYELLTT = "Establece el color para el nombre de PNJ",

	RCHAT_NPCYELLCHAT = "PNJ Gritos - Chat",
	RCHAT_NPCYELLCHATTT = "Establece el color del mensaje para gritos de PNJs",

	RCHAT_NPCWHISPER = "PNJ Susurros - Nombre PNJ",
	RCHAT_NPCWHISPERTT = "Establece el color para el nombre de PNJ",

	RCHAT_NPCWHISPERCHAT = "PNJ Susurros - Chat",
	RCHAT_NPCWHISPERCHATTT = "Establece el color del mensaje para susurros de PNJs",

	RCHAT_NPCEMOTES = "PNJ Emoticones - Nombre PNJ",
	RCHAT_NPCEMOTESTT = "Establece el color para el nombre de PNJ",

	RCHAT_NPCEMOTESCHAT = "PNJ Emoticones - Chat",
	RCHAT_NPCEMOTESCHATTT = "Establece el color del mensaje para emoticones de PNJs",

	-- Debug settings

	RCHAT_DEBUGH = "Depuración",

	RCHAT_DEBUG = "Depuración",
	RCHAT_DEBUGTT = "Depuración",

	-- Various strings not in panel settings

	RCHAT_UNDOCKTEXTENTRY = "Undock Text Entry",
	RCHAT_REDOCKTEXTENTRY = "Redock Text Entry",

	RCHAT_COPYXMLTITLE = "Copie el texto con Ctrl + C",
	RCHAT_COPYXMLLABEL = "Copie el texto con Ctrl + C",
	RCHAT_COPYXMLTOOLONG = "El texto es demasiado largo y está dividido",
	RCHAT_COPYXMLNEXT = "Siguiente",

	RCHAT_COPYMESSAGECT = "Copiar mensaje",
	RCHAT_COPYLINECT = "Copiar linea",
	RCHAT_COPYDISCUSSIONCT = "Copiar conversación de canal",
	RCHAT_ALLCT = "Copiar chat completo",

	RCHAT_SWITCHTONEXTTABBINDING = "Switch to next tab",
	RCHAT_TOGGLECHATBINDING = "Activar la ventana de charla",
	RCHAT_WHISPMYTARGETBINDING = "Whisper my target",

	RCHAT_SAVMSGERRALREADYEXISTS = "Cannot save your message, this one already exists",
	RCHAT_RCHAT_AUTOMSG_NAME_DEFAULT_TEXT = "Example : ts3",
	RCHAT_RCHAT_AUTOMSG_MESSAGE_DEFAULT_TEXT = "Write here the text which will be sent when you'll be using the auto message function",
	RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP1_TEXT = "Newlines will be automatically deleted",
	RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP2_TEXT = "This message will be sent when you'll validate the message \"!nameOfMessage\". (ex: |cFFFFFF!ts3|r)",
	RCHAT_RCHAT_AUTOMSG_MESSAGE_TIP3_TEXT = "To send a message in a specified channel, add its switch at the begenning of the message (ex: |cFFFFFF/g1|r)",
	RCHAT_RCHAT_AUTOMSG_NAME_HEADER = "Abbreviation of your message",
	RCHAT_RCHAT_AUTOMSG_MESSAGE_HEADER = "Substitution message",
	RCHAT_RCHAT_AUTOMSG_ADD_TITLE_HEADER = "New automated message",
	RCHAT_RCHAT_AUTOMSG_EDIT_TITLE_HEADER = "Modify automated message",
	RCHAT_RCHAT_AUTOMSG_ADD_AUTO_MSG = "Add",
	RCHAT_RCHAT_AUTOMSG_EDIT_AUTO_MSG = "Edit",
	RCHAT_SI_BINDING_NAME_RCHAT_SHOW_AUTO_MSG = "Automated messages",
	RCHAT_RCHAT_AUTOMSG_REMOVE_AUTO_MSG = "Remove",

	RCHAT_CLEARBUFFER = "Clear chat",
}

