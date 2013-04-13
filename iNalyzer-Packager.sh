#!/bin/sh
#
# PoedCrackMod v25L beta9 (october 2011)
# iNalyzer mod v1.0b (september 2012)
#
# Rapid Advanced Secure Thorough Intelligent Gaulish Nuclear Acclaimed Cracker
# Rapide Avance Securise Tout-terrain Intelligent Gaulois Nucleaire Approfondi Craqueur
#
# For all devices, for all iOS versions.
# Pour toutes les iMachines, quelque soit la version de l'iOS.
#
# For every kind of people, to make the world go round.
# Un bon script et une bonne biere belge bien fraiche: que demande le peuple ?
#
# Now includes full working fat binary support and many many features.
# Il sait tout faire, et bien plus encore.
#
#
# The truth is I never left you. I kept my promise.
#
#
# Based upon poedGirl's ancient poedCrack (December 2009).
# poedGirl's version available at: http://www.roapd.com/uploads/poedCrack.gz
# poedCrack is heavily based on DeCrypt by FloydianSlip
# Many thanks to:
# puy0, SaladFork, Flox, Flawless, FloydianSlip, MadHouse, TDDebug
# and every helping people !



# ======
# Please, customize the script first !
# Choices are:

# - Default language (US:english, FR:french, ES:spanish, DE:german).
 PCMlang="US"
#PCMlang="FR1"
#PCMlang="FR2"
#PCMlang="ES1"
#PCMlang="ES2"
#PCMlang="DE1"
#PCMlang="DE2"

# - Default CrackerName (or "Anonymous").
PCMcracker="Anonymous"

# - Should "extra details" appear in Ipa name (ie: "iPad / 3GS / InApp / etc") ? (You can hate them)
PCMextras="YES"

# - Display graphical progress bars ? (based on number and/or size of apps) ("by size" is slower)
PCMbarNum="YES"
PCMbarSize="YES"

# - Should display be verbose ? (verbose is slower and messier)
PCMverbose="NO"

# - Should script talk to you ? (it only speaks english, only with iOS4+, only with "speak" tool from Cydia)
PCMspeak="YES"

# - Should artist's name be used in filename ?
PCMartistfrommeta="YES"

# - Default compression level is blank (aka "-6"), and is the best speed/size ratio.
# - Recommended. Upload/download/storage will be good.
 PCMcompression="-0"
# - Maximum compression ("-9") (also "-8" or "-7") is very very slow, but size is the best.
# - If your iDevice is fast, if you're not in a hurry, if size matters. Best upload/download/storage.
#PCMcompression="-9"
# - Minimum compression ("-2") (also "-3" to "-5") is way faster, but size is way worse.
# - Upload/download/storage will be worse. (CrackTM and iNalyzer5 and newest Crackulous use "-2").
# - With "-2", PCM will be as fast as the others.
#PCMcompression="-2"
# - Don't use "-1" (sloppy) or "-0" (store), as size will be horrible, and all will suffer. Avoid.

# - Should I generate fake MetaData or not ?
#   (Some people hate them, some love them, some protections check them, you should really keep them)
PCMmetadata="YES"

# - Should I try LamestPatchest on the executable ?
#   (It won't work 100%, but sometimes it really helps) (and now it's very very fast) (you should keep it)
PCMlamestpatchest="YES"

# - What menu dots do you prefer ?
#PCMdots="$( echo -e -n "\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267\0267" )"
 PCMdots=".............................."
#PCMdots="				"
#PCMdots="------------------------------"
#PCMdots="______________________________"
# NOT PCMdots="$( echo -e -n "\0302\0267\0302\0267" )"

# Progress bar display
PCMxxx="====="
PCMsss="-----"

# DEBUG ONLY: - Should I try to crack arm6+arm7 on arm6 devices ? (It won't work at all)
PCMarm7onarm6="NEVER"
# DEBUG ONLY: - Force the "this script is running inside a GUI" check ?
PCMinaGUI="NEVER"
# DEBUG ONLY: - Check only (all tested but Ipa not created)
PCMcheck="NEVER"

# Thanks you for testing.
# ======


# ======
function SelectLanguage
{
# Language US
if [ $PCMlang = "US" ]; then
	MsgAltMeth="Using alternative dumping method"
	MsgAnaAppl="Analyzing application"
	MsgAppLoca="Locating"
	MsgBadChoi="Bad choice"
	MsgBldMenu="Building menu..."
	MsgBrzMode="Berzerk mode: cracking ALL"
	MsgCntFind="Cannot find"
	MsgCopExec="and copying executable"
	MsgCreDire="Creating directories"
	MsgDmpUncr="Dumping unencrypted data from application"
	MsgIpaInco="Incomplete .ipa"
	MsgDskFull="Disk full"
	MsgEraMemo="Erasing memory file"
	MsgInsCydi="Install from Cydia"
	MsgIpaDone="Done as"
	MsgMnuEmpt="empty"
	MsgMrkDone="Marking all apps done"
	MsgPatCryp="Locating and patching CryptID"
	MsgRemTemp="Removing temporary files"
	MsgRepData="and replacing encrypted data"
	MsgSizUnit="B"
	MsgUnaLoca="Unable to locate"
	MsgVrfDump="Verifying dump"
	MsgWrgChoi="Wrong choice"
	MsgWrnMeta="Warning: iTunesMetadata format changed"
	MsgYouChoi="Your choices"
	MsgZipStep="Compressing the .ipa (step"
	MsgComBoth="Combining both parts into a fat binary"
	MsgSgnAppl="Signing the application"
	MsgCopArtw="Copying Artwork"
	MsgFakMeta="and faking MetaData"
	MsgNotMeta="and no MetaData"
	MsgFoundIt="Found"
	MsgWasAskd="Asked"
	MsgErrrors="Errors"
	MsgBrzNoth="nothing"
	MsgMrkDone="Mark all done		  "
	MskZroDone="Reset done list		  "
fi

# Language FR1 (ascii)
if [ $PCMlang = "FR1" ]; then
	MsgAltMeth="$( echo -e -n "M\0351thode alternative de dumping" )"
	MsgAnaAppl="Analyse d'application"
	MsgAppLoca="Recherche"
	MsgBadChoi="$( echo -e -n "Choix erron\0351" )"
	MsgBldMenu="Construction du menu..."
	MsgBrzMode="Mode Berzerk: on craque TOUT"
	MsgCntFind="Introuvable:"
	MsgCopExec="$( echo -e -n "& copie de l'ex\0351cutable" )"
	MsgCreDire="$( echo -e -n "Cr\0351ation r\0351pertoires" )"
	MsgDmpUncr="$( echo -e -n "Extraction des donn\0351es d\0351crypt\0351es de l'appli" )"
	MsgIpaInco="$( echo -e -n "Ipa incompl\0350te" )"
	MsgDskFull="Disque plein"
	MsgEraMemo="$( echo -e -n "Effacement fichier m\0351moire" )"
	MsgInsCydi="Installer avec Cydia"
	MsgIpaDone="$( echo -e -n "R\0351sultat:" )"
	MsgMnuEmpt="vide"
	MsgMrkDone="$( echo -e -n "Toutes les apps sont marqu\0351es comme trait\0351es" )"
	MsgPatCryp="$( echo -e -n "Localisation et \0351crasement du CryptID" )"
	MsgRemTemp="Effacement fichiers temporaires"
	MsgRepData="$( echo -e -n "et remplacement par d\0351crypt\0351es" )"
	MsgSizUnit="o"
	MsgUnaLoca="Impossible de trouver"
	MsgVrfDump="$( echo -e -n "V\0351rif donn\0351es" )"
	MsgWrgChoi="Mauvais choix"
	MsgWrnMeta="Attention: nouveau format d'iTunesMetadata"
	MsgYouChoi="Votre choix"
	MsgZipStep="$( echo -e -n "Compression de l'ipa (\0351tape" )"
	MsgComBoth="Consolidation des deux sections binaires"
	MsgSgnAppl="Signature de l'application"
	MsgCopArtw="Copie de l'Artwork"
	MsgFakMeta="et fausses MetaData"
	MsgNotMeta="et pas de MetaData"
	MsgFoundIt="$( echo -e -n "Trouv\0351" )"
	MsgWasAskd="Voulu"
	MsgErrrors="Erreurs"
	MsgBrzNoth="rien"
	MsgMrkDone="Tout marquer fait		  "
	MskZroDone="Effacer liste fait		  "
fi

# Language FR2 (utf8)
if [ $PCMlang = "FR2" ]; then
	MsgAltMeth="$( echo -e -n "M\0303\0251thode alternative de dumping" )"
	MsgAnaAppl="Analyse d'application"
	MsgAppLoca="Recherche"
	MsgBadChoi="$( echo -e -n "Choix erron\0303\0251" )"
	MsgBldMenu="Construction du menu..."
	MsgBrzMode="Mode Berzerk: on craque TOUT"
	MsgCntFind="Introuvable:"
	MsgCopExec="$( echo -e -n "& copie de l'ex\0303\0251cutable" )"
	MsgCreDire="$( echo -e -n "Cr\0303\0251ation r\0303\0251pertoires" )"
	MsgDmpUncr="$( echo -e -n "Extraction des donn\0303\0251es d\0303\0251crypt\0303\0251es de l'appli" )"
	MsgIpaInco="$( echo -e -n "Ipa incompl\0303\0250te" )"
	MsgDskFull="Disque plein"
	MsgEraMemo="$( echo -e -n "Effacement fichier m\0303\0251moire" )"
	MsgInsCydi="Installer avec Cydia"
	MsgIpaDone="$( echo -e -n "R\0303\0251sultat:" )"
	MsgMnuEmpt="vide"
	MsgMrkDone="$( echo -e -n "Toutes les apps sont marqu\0303\0251es comme trait\0303\0251es" )"
	MsgPatCryp="$( echo -e -n "Localisation et \0303\0251crasement du CryptID" )"
	MsgRemTemp="Effacement fichiers temporaires"
	MsgRepData="$( echo -e -n "et remplacement par d\0303\0251crypt\0303\0251es" )"
	MsgSizUnit="o"
	MsgUnaLoca="Impossible de trouver"
	MsgVrfDump="$( echo -e -n "V\0303\0251rif donn\0303\0251es" )"
	MsgWrgChoi="Mauvais choix"
	MsgWrnMeta="Attention: nouveau format d'iTunesMetadata"
	MsgYouChoi="Votre choix"
	MsgZipStep="$( echo -e -n "Compression de l'ipa (\0303\0251tape" )"
	MsgComBoth="Consolidation des deux sections binaires"
	MsgSgnAppl="Signature de l'application"
	MsgCopArtw="Copie de l'Artwork"
	MsgFakMeta="et fausses MetaData"
	MsgNotMeta="et pas de MetaData"
	MsgFoundIt="$( echo -e -n "Trouv\0303\0251" )"
	MsgWasAskd="Voulu"
	MsgErrrors="Erreurs"
	MsgBrzNoth="rien"
	MsgMrkDone="Tout marquer fait		  "
	MskZroDone="Effacer liste fait		  "
fi

# Language ES1 (ascii)
if [ $PCMlang = "ES1" ]; then
	MsgAltMeth="$( echo -e -n "Usando m\0351todo alternativo de dumping" )"
	MsgAnaAppl="$( echo -e -n "Analizando aplicaci\0363n" )"
	MsgAppLoca="$( echo -e -n "Ubicaci\0363n" )"
	MsgBadChoi="$( echo -e -n "Mala elecci\0363n" )"
	MsgBldMenu="$( echo -e -n "Construyendo men\0372..." )"
	MsgBrzMode="Modo Berzerk: crackando TODO"
	MsgCntFind="No encontro"
	MsgCopExec="y copiando ejecutable"
	MsgCreDire="Creando directorios"
	MsgDmpUncr="$( echo -e -n "Dumping decifrados datos de la aplicaci\0363n" )"
	MsgIpaInco="$( echo -e -n "\0241 Incompleta .ipa" )"
	MsgDskFull="$( echo -e -n "\0277 Disco lleno" )"
	MsgEraMemo="Borrado memoria archivo"
	MsgInsCydi="Instalarlo desde Cydia"
	MsgIpaDone="Done as"
	MsgMnuEmpt="$( echo -e -n "vac\0355o" )"
	MsgMrkDone="Marcando todas aplicaciones como 'hecho'"
	MsgPatCryp="Locating y patching CryptID"
	MsgRemTemp="Borrando archivos temporales"
	MsgRepData="y reemplazando datos cifrados"
	MsgSizUnit="B"
	MsgUnaLoca="Incapaz de ubicar"
	MsgVrfDump="$( echo -e -n "Verificaci\0363n" )"
	MsgWrgChoi="$( echo -e -n "Opci\0363n incorrecta" )"
	MsgWrnMeta="Warning: iTunesMetadata formato cambiado"
	MsgYouChoi="$( echo -e -n "\0277 Su elecci\0363" )"
	MsgZipStep="$( echo -e -n "Compresi\0363n de .ipa (paso" )"
	MsgComBoth="$( echo -e -n "Combinaci\0363n dos partes en fat binary" )"
	MsgSgnAppl="$( echo -e -n "Firma de la aplicaci\0363n" )"
	MsgCopArtw="Copiando Artwork"
	MsgFakMeta="y fingiendo MetaData"
	MsgNotMeta="y no MetaData"
	MsgFoundIt="Found"
	MsgWasAskd="Asked"
	MsgErrrors="Errores"
	MsgBrzNoth="nada"
	MsgMrkDone="Marcar todas hechas 	  "
	MskZroDone="Vaciar lista hechas 	  "
fi

# Language ES2 (utf8)
if [ $PCMlang = "ES2" ]; then
	MsgAltMeth="$( echo -e -n "Usando m\0303\0251todo alternativo de dumping" )"
	MsgAnaAppl="$( echo -e -n "Analizando aplicaci\0303\0263n" )"
	MsgAppLoca="$( echo -e -n "Ubicaci\0303\0263n" )"
	MsgBadChoi="$( echo -e -n "Mala elecci\0303\0263n" )"
	MsgBldMenu="$( echo -e -n "Construyendo men\0303\0272..." )"
	MsgBrzMode="Modo Berzerk: crackando TODO"
	MsgCntFind="No encontro"
	MsgCopExec="y copiando ejecutable"
	MsgCreDire="Creando directorios"
	MsgDmpUncr="$( echo -e -n "Dumping decifrados datos de la aplicaci\0303\0263n" )"
	MsgIpaInco="$( echo -e -n "\0302\0241 Incompleta .ipa" )"
	MsgDskFull="$( echo -e -n "\0302\0277 Disco lleno" )"
	MsgEraMemo="Borrado memoria archivo"
	MsgInsCydi="Instalarlo desde Cydia"
	MsgIpaDone="Done as"
	MsgMnuEmpt="$( echo -e -n "vac\0303\0255o" )"
	MsgMrkDone="Marcando todas aplicaciones como 'hecho'"
	MsgPatCryp="Locating y patching CryptID"
	MsgRemTemp="Borrando archivos temporales"
	MsgRepData="y reemplazando datos cifrados"
	MsgSizUnit="B"
	MsgUnaLoca="Incapaz de ubicar"
	MsgVrfDump="$( echo -e -n "Verificaci\0303\0263n" )"
	MsgWrgChoi="$( echo -e -n "Opci\0303\0263n incorrecta" )"
	MsgWrnMeta="Warning: iTunesMetadata formato cambiado"
	MsgYouChoi="$( echo -e -n "\0302\0277 Su elecci\0303\0263" )"
	MsgZipStep="$( echo -e -n "Compresi\0303\0263n de .ipa (paso" )"
	MsgComBoth="$( echo -e -n "Combinaci\0303\0263n dos partes en fat binary" )"
	MsgSgnAppl="$( echo -e -n "Firma de la aplicaci\0303\0263n" )"
	MsgCopArtw="Copiando Artwork"
	MsgFakMeta="y fingiendo MetaData"
	MsgNotMeta="y no MetaData"
	MsgFoundIt="Found"
	MsgWasAskd="Asked"
	MsgErrrors="Errores"
	MsgBrzNoth="nada"
	MsgMrkDone="Marcar todas hechas 	  "
	MskZroDone="Vaciar lista hechas 	  "
fi

# Language DE1 (ascii). Translation by Ushnak.
if [ $PCMlang = "DE1" ]; then
	MsgAltMeth="Alternative Methode zum Dumpen"
	MsgAnaAppl="Analyse der App"
	MsgAppLoca="Suche"
	MsgBadChoi="$( echo -e -n "Ung\0374ltige Wahl" )"
	MsgBldMenu="$( echo -e -n "Aufbau des Men\0374s..." )"
	MsgBrzMode="Berzerker Modus: ALLES wird gecrackt"
	MsgcntFind="Nicht aufzufinden:"
	MsgCopExec="Kopieren der Executable"
	MsgCreDire="Erstellen der Ordner"
	MsgDmpUncr="$( echo -e -n "Dumping von unverschl\0374sselten Daten der App" )"
	MsgIpaInco="$( echo -e -n "Unvollst\0344ndige .ipa" )"
	MsgDskFull="Kein Speicher mehr"
	MsgEraMemo="$( echo -e -n "L\0366schen des Zwischenspeichers" )"
	MsgInsCydi="Installieren mit Cydia"
	MsgIpaDone="Fertig"
	MsgMnuEmpt="leer"
	MsgMrkDone="Alle Apps als gecrackt markieren"
	MsgPatCryp="Aufinden und patchen der CryptID"
	MsgRemTemp="$( echo -e -n "L\0366schen des Speichers" )"
	MsgRepData="$( echo -e -n "und Austausch der verschl\0374sselten Daten" )"
	MsgSizUnit="B"
	MsgUnaLoca="$( echo -e -n "Unm\0366glich zu Finden" )"
	MsgVrfDump="$( echo -e -n "\0334perpr\0374fen des Dumps" )"
	MsgWrgChoi="Schlechte Wahl"
	MsgWrnMeta="$( echo -e -n "Warnung: Das Format der iTunesMetaData wurde ge\0344ndert" )"
	MsgYouChoi="Ihre Wahl"
	MsgZipStep="Kompression der .ipa (Schritt"
	MsgComBoth="$( echo -e -n "Zusammensetzung der zwei Bin\0344rdateien" )"
	MsgSgnAppl="Signieren der App"
	MsgCopArtw="Kopieren des Artworks"
	MsgFakMeta="und der falschen MetaData"
	MsgNotMeta="und keine MetaData"
	MsgFoundIt="Gefunden"
	MsgWasAskd="Angefragt"
	MsgErrrors="Fehler"
	MsgBrzNoth="Nichts"
	MsgMrkDone="$( echo -e -n "Alles als angew\0344hlt	     " )"
	MskZroDone="$( echo -e -n "Liste der angew\0344hlten l\0366schen " )"
fi

# Language DE2 (utf8). Translation by Ushnak.
if [ $PCMlang = "DE2" ]; then
	MsgAltMeth="Alternative Methode zum Dumpen"
	MsgAnaAppl="Analyse der App"
	MsgAppLoca="Suche"
	MsgBadChoi="$( echo -e -n "Ung\0303\0274ltige Wahl" )"
	MsgBldMenu="$( echo -e -n "Aufbau des Men\0303\0274s..." )"
	MsgBrzMode="Berzerker Modus: ALLES wird gecrackt"
	MsgcntFind="Nicht aufzufinden:"
	MsgCopExec="Kopieren der Executable"
	MsgCreDire="Erstellen der Ordner"
	MsgDmpUncr="$( echo -e -n "Dumping von unverschl\0303\0274sselten Daten der App" )"
	MsgIpaInco="$( echo -e -n "Unvollst\0303\0244ndige .ipa" )"
	MsgDskFull="Kein Speicher mehr"
	MsgEraMemo="$( echo -e -n "L\0303\0266schen des Zwischenspeichers" )"
	MsgInsCydi="Installieren mit Cydia"
	MsgIpaDone="Fertig"
	MsgMnuEmpt="leer"
	MsgMrkDone="Alle Apps als gecrackt markieren"
	MsgPatCryp="Aufinden und patchen der CryptID"
	MsgRemTemp="$( echo -e -n "L\0303\0266schen des Speichers" )"
	MsgRepData="$( echo -e -n "und Austausch der verschl\0303\0274sselten Daten" )"
	MsgSizUnit="B"
	MsgUnaLoca="$( echo -e -n "Unm\0303\0266glich zu Finden" )"
	MsgVrfDump="$( echo -e -n "\0303\0234perpr\0303\0274fen des Dumps" )"
	MsgWrgChoi="Schlechte Wahl"
	MsgWrnMeta="$( echo -e -n "Warnung: Das Format der iTunesMetaData wurde ge\0303\0244ndert" )"
	MsgYouChoi="Ihre Wahl"
	MsgZipStep="Kompression der .ipa (Schritt"
	MsgComBoth="$( echo -e -n "Zusammensetzung der zwei Bin\0303\0244rdateien" )"
	MsgSgnAppl="Signieren der App"
	MsgCopArtw="Kopieren des Artworks"
	MsgFakMeta="und der falschen MetaData"
	MsgNotMeta="und keine MetaData"
	MsgFoundIt="Gefunden"
	MsgWasAskd="Angefragt"
	MsgErrrors="Fehler"
	MsgBrzNoth="Nichts"
	MsgMrkDone="$( echo -e -n "Alles als angew\0303\0244hlt 	  " )"
	MskZroDone="$( echo -e -n "Liste der angew\0303\0244hlten l\0303\0266schen " )"
fi
}


# ======
function UnicodeToHuman
{
# Convert from unicode to human, and remove unwanted chars
human=$(echo -n "$unicode" | sed -e "s: :_:g" | od -c -A n -v --width=999 | sed \
	-e 's:+:Plus:g' \
	-e 's:302.240:_:g' \
	-e 's:302.251:_:g' \
	-e 's:302.256:_:g' \
	-e 's:302.260:Degree:g' \
	-e "s:302.264:':g" \
	-e 's:303.201:A:g' \
	-e 's:303.207:C:g' \
	-e 's:303.211:E:g' \
	-e 's:303.216:I:g' \
	-e 's:303.224:O:g' \
	-e 's:303.234:U:g' \
	-e 's:303.240:a:g' \
	-e 's:303.241:a:g' \
	-e 's:303.242:a:g' \
	-e 's:303.245:a:g' \
	-e 's:303.247:c:g' \
	-e 's:303.250:e:g' \
	-e 's:303.251:e:g' \
	-e 's:303.252:e:g' \
	-e 's:303.253:e:g' \
	-e 's:303.255:i:g' \
	-e 's:303.256:i:g' \
	-e 's:303.257:i:g' \
	-e 's:303.263:o:g' \
	-e 's:303.264:o:g' \
	-e 's:303.266:o:g' \
	-e 's:303.270:o:g' \
	-e 's:303.271:u:g' \
	-e 's:303.273:u:g' \
	-e 's:303.274:u:g' \
	-e 's:304.237:g:g' \
	-e 's:304.261:i:g' \
	-e 's:305.223:oe:g' \
	-e 's:312.236:k:g' \
	-e 's:316.251:Omega:g' \
	-e 's:342.200.223:-:g' \
	-e 's:342.200.224:-:g' \
	-e "s:342.200.230:':g" \
	-e "s:342.200.231:':g" \
	-e 's:342.200.242:-:g' \
	-e 's:342.202.254:EUR:g' \
	-e 's:342.204.242:_:g' \
	-e 's:342.213.205:.:g' \
	-e 's:342.226.272:_:g' \
	-e 's:342.227.217:-:g' \
	-e 's:342.230.205:_:g' \
	-e 's:342.231.253:_:g' \
	-e 's:342.235.222:_:g' \
	-e 's:347.246.205:_:g' \
	| tr -cd "[:alnum:][_'.][-]" | sed -e "s:_: :g" | sed -e "s:  : :g" )
# Todo: future enhancements
# Help wanted for unknown or other unicodes
}


# ======
function DisplayBars
{
ProgressPct=""
if [ $PCMbarNum = "YES" ]; then
	ProgressXXX=$(( $BarCols * $ProgressDone / $ProgressTarget ))
	ProgressSSS=$(( $BarCols - $ProgressXXX ))
	ProgressPct=$(( 100 * $ProgressDone / $ProgressTarget ))
	echo "[${escGreen}${PCMxxx:0:$ProgressXXX}${escBlue}${PCMsss:0:$ProgressSSS}${escReset}] $ProgressPct%"
fi
if [ $PCMbarSize = "YES" ]; then
	ProgressXXX=$(( $BarCols * $ProgressDoneSize / $ProgressTargetSize ))
	ProgressSSS=$(( $BarCols - $ProgressXXX ))
	ProgressPct=$(( 100 * $ProgressDoneSize / $ProgressTargetSize ))
	echo "[${escCyan}${PCMxxx:0:$ProgressXXX}${escBlue}${PCMsss:0:$ProgressSSS}${escReset}] $ProgressPct%"
fi

if [ ! -z "$ProgressPct" -a $PCMspeak = "YES" ]; then
	speak "$ProgressPct %" &
fi
}

function iNalyzer
{

#iNalyzer# Creating Strings Dump
echo "${Meter75}iNalyzer:Dumping Strings"
mkdir -p "$WorkDir/Payload/ReversingFiles"
mkdir -p "$WorkDir/Payload/ClientFiles"
d001=$( cp -r "$AppPath/" "$WorkDir/Payload/ClientFiles" 2>/dev/null )
mkdir -p "$WorkDir/Payload/Doxigen"
d0=$( cp "/Applications/AppSecLabsiNalyzer.app/footer.html" "$WorkDir/Payload/Doxigen/footer.html" 2>&1>/dev/null )
d0=$( cp "/Applications/AppSecLabsiNalyzer.app/logo.png" "$WorkDir/Payload/Doxigen/logo.png" 2>&1>/dev/null )
d0=$( cp "/Applications/AppSecLabsiNalyzer.app/dox.template" "$WorkDir/Payload/Doxigen/dox.template" 2>&1>/dev/null )
d0=$( echo "/Applications/Doxygen.app/Contents/Resources/doxygen dox.template" 1>"$WorkDir/Payload/Doxigen/doxMe.sh" 2>/dev/null )
d0=$( chmod +x "$WorkDir/Payload/Doxigen/doxMe.sh" 2>&1>/dev/null )
export safename=$( echo $AppName | tr '.' '_' | tr '/' '_' | tr ' ' '_' )
d1=$( sed 's/§PNAME§/'$safename'/g' "$WorkDir/Payload/Doxigen/dox.template" > "$WorkDir/Payload/Doxigen/dox.template_")
d2=$( sed 's/§OUTDIR§/"\."/g' "$WorkDir/Payload/Doxigen/dox.template_" > "$WorkDir/Payload/Doxigen/dox.template__")
d3=$( sed 's/§INDIR§/"\.\.\/ReversingFiles"/g' "$WorkDir/Payload/Doxigen/dox.template__" > "$WorkDir/Payload/Doxigen/dox.template")
d4=$( rm "$WorkDir/Payload/Doxigen/dox.template__" "$WorkDir/Payload/Doxigen/dox.template_" )

d3=$( sed 's/§EXENAME§/'$AppExec'/g' "$WorkDir/Payload/Doxigen/footer.html" > "$WorkDir/Payload/Doxigen/footer.html_" )
d4=$( mv "$WorkDir/Payload/Doxigen/footer.html_" "$WorkDir/Payload/Doxigen/footer.html" )

LocIP=$(python -c "import socket; s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM); s.connect(('8.8.8.8', 80)); print(s.getsockname()[0]); s.close()")

d3=$( sed 's/§IPHONEIP§/'$LocIP'/g' "$WorkDir/Payload/Doxigen/footer.html" > "$WorkDir/Payload/Doxigen/footer.html_" )
d4=$( mv "$WorkDir/Payload/Doxigen/footer.html_" "$WorkDir/Payload/Doxigen/footer.html" )

c=$( printf "/*! \\page EMS Embeded Strings \n\section all strings\n\\code\n" 2>/dev/null 1> "$WorkDir/Payload/ReversingFiles/__String_dump__.h" )

d=$( strings - "$WorkDir/Payload/$AppName/$AppExec" 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR" "$0 }'  2>/dev/null 1>> "$WorkDir/Payload/ReversingFiles/__String_dump__.h" ) 

e=$( printf "\\\endcode*/"   2>/dev/null 1>>"$WorkDir/Payload/ReversingFiles/__String_dump__.h" )


dc=$( printf "/*! \\page InfoPlist Info.Plist Content \n\section data\n" 2>/dev/null 1> "$WorkDir/Payload/ReversingFiles/__InfoPlist__.h" )
dd=$(plutil -show "$AppPath/$AppName/Info.plist" 2>&1 | tr ';' '\n' 1>> "$WorkDir/Payload/ReversingFiles/__InfoPlist__.h" 2>&1 )
de=$( printf "\\endpage*/"   2>/dev/null 1>>"$WorkDir/Payload/ReversingFiles/__InfoPlist__.h" )

#iNalyzer# Creating URI and SQL Dump
echo "${Meter75}iNalyzer:Dumping URI/SQL Strings"
c=$( printf "/*! \\mainpage Strings analysis\nAnalysis of Strings found in the executable\n\section SQL SQL Strings\n" 2>/dev/null 1> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h" )

d=$( grep -iE  '(DELETE.*FROM)|(INSERT.*TO)|(SELECT.*FROM)|(UPDATE.*WHERE)' "$WorkDir/Payload/ReversingFiles/__String_dump__.h" 2>/dev/null | sort -iu 2>/dev/null | awk '{print FNR" "$0"\n"}' 2>/dev/null 1>> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h" )

dd= $( grep -iE  '(DELETE.*FROM)|(INSERT.*TO)|(SELECT.*FROM)|(UPDATE.*WHERE)' "$WorkDir/Payload/ReversingFiles/__String_dump__.h" 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR" "$0"\n"}' 2>/dev/null 1> /var/root/Documents/SQL_results.txt )

c=$( printf "\n\section URI URI strings\n" 2>/dev/null 1>> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h" ) 

d=$( grep -iE  '(:\/\/)|(:\/\/)' "$WorkDir/Payload/ReversingFiles/__String_dump__.h" 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR" "$0"\n"}' 2>/dev/null 1>> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h" )

dd= $( grep -iE  '(:\/\/)|(:\/\/)' "$WorkDir/Payload/ReversingFiles/__String_dump__.h" 2>/dev/null  | sort -iu 2>/dev/null | awk '{print FNR" "$0"\n"}' 2>/dev/null 1> /var/root/Documents/URI_results.txt )


e=$( printf "*/" 2>/dev/null 1>> "$WorkDir/Payload/ReversingFiles/__iNalyzer__.h" )

echo "${Meter75}iNalyzer:Dumping Headers"
class-dump-z -H -k -k -o "$WorkDir/Payload/ReversingFiles" "$WorkDir/Payload/$AppName/$AppExec"
#fix hidden attribute in header files"

cd "$WorkDir/Payload/ReversingFiles"
echo "${Meter75}iNalyzer:Patching Headers"
headers=$( ls "$WorkDir/Payload/ReversingFiles/" | grep .h )
for f in $headers
	do
	b=$( cat ${f} 2>/dev/null | sed 's/__attribute__((visibility("hidden")))//g' > ${f}_fixed )
	a=$( mv ./${f}_fixed ${f} 2>&1> /dev/null)
done
cd - 2>&1>/dev/null
#exit

}

# ======
# Begin Core Function

function CoreFunction
{
AppInput=$1
CrackerName=$2
CreditFile=$3

if [ ! "$CrackerName" ]; then
	CrackerName="$PCMcracker"
fi

if [ ! "$CreditFile" ]; then
	CreditFile="$CrackerName"
fi

# Script has app's full directory path as input (ie: called from GUI)
if [ -d "$AppInput" ]; then
	tempLoc=$AppInput
else
	# Script has app's name as input
	echo "$MsgAppLoca '$AppInput'"
	# Escape the "*" as ".*"
	AppGrep=$(echo "/$AppInput\.app" | sed "s:\*:\.\*:g")
	if [ -e /tmp/lsd.tmp ]; then
		tempLoc=$(grep -i "$AppGrep" /tmp/lsd.tmp)
	else
		tempLoc=""
	fi
	if [ -z "$tempLoc" ]; then
		echo "$MsgUnaLoca '$AppInput'"
		rm -f /tmp/lsd.tmp
		return 1
	fi
	AppCount=$(echo "$tempLoc" | wc -l)
	if [ $AppCount -gt 1 ]; then
		echo "$MsgFoundIt $AppCount installation directories:"
		echo "$tempLoc"
		rm -f /tmp/lsd.tmp
		return 1
	fi
fi

# The app has been found
MenuFound=$(($MenuFound + 1))
AppPath=$(dirname "$tempLoc")
AppName=$(basename "$tempLoc")
echo -n "${Meter4}${escCyan}$MsgFoundIt ${escReset}'$(echo $AppName | sed "s:\\.app::")': "

if [ ! -d "$AppPath" ]; then
	echo "$MsgUnaLoca original installation directory"
	return 1
fi
if [ ! -d "$AppPath/$AppName" ]; then
	echo "$MsgUnaLoca .app directory"
	return 1
fi
AppExec=$(plutil -key CFBundleExecutable "$tempLoc/Info.plist" 2> /dev/null)
if [ ! -e "$AppPath/$AppName/$AppExec" ]; then
	echo "$MsgUnaLoca executable"
	return 1
fi
# Get the name from MetaData
AppDisplayName=$(plutil -key itemName "$AppPath/iTunesMetadata.plist" 2> /dev/null)
# No alphanum characters at all ?
AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
if [ "$AppDisplayNameAlpha" = "" ]; then
	#echo "${Meter5}Warning: non-alpha name !"
	AppDisplayName=""
fi
# Get the name from InfoPlist or from executable name
if [ "$AppDisplayName" = "" ]; then
	AppDisplayName=$(plutil -key CFBundleDisplayName "$tempLoc/Info.plist" 2> /dev/null)
	AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
	if [ "$AppDisplayNameAlpha" = "" ]; then
		AppDisplayName=$(plutil -key CFBundleName "$tempLoc/Info.plist" 2> /dev/null)
		AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
		if [ "$AppDisplayNameAlpha" = "" ]; then
			AppDisplayName=$AppExec
			#AppDisplayNameAlpha=$(echo -n "$AppDisplayName" | tr -cd "[:alnum:]")
			#if [ "$AppDisplayNameAlpha" = "" ]; then
			#	echo "${Meter6}Warning: too exotic name !"
			#fi
		fi
	fi
fi

# Convert AppName from unicode to human
unicode=$AppDisplayName
UnicodeToHuman
AppDisplayName=$human

# Get the artist name from MetaData
if [ $PCMartistfrommeta = "YES" ]; then
	artistName=$(plutil -key artistName "$AppPath/iTunesMetadata.plist" 2> /dev/null)
	artistNameAlpha=$(echo -n "$artistName" | tr -cd "[:alnum:]")
	# At least some alphanum inside ?
	if [ "$artistNameAlpha" != "" ]; then
		# Convert from unicode to human
		unicode=$artistName
		UnicodeToHuman
		AppDisplayName="$AppDisplayName [$human]"
	fi
fi

# Show the real human name of the app
echo "${Meter5}$AppDisplayName"

# Dealing with version numbers
AppVer=$(plutil -key CFBundleVersion "$tempLoc/Info.plist" 2> /dev/null | tr -d "\n\r")
AppShortVer=$(plutil -key CFBundleShortVersionString "$tempLoc/Info.plist" 2> /dev/null | tr -d "\n\r")
if [ ! "$AppShortVer" = "" ]; then
	if [ ! "$AppShortVer" = "$AppVer" ]; then
		AppVer="$AppShortVer v$AppVer"
	fi
fi
MinOS=$(plutil -key MinimumOSVersion "$tempLoc/Info.plist" 2> /dev/null | tr -d ".")
if [ "$MinOS" = "" ]; then
	echo "${Meter7}${escYellow}Warning${escReset}: unable to get MinOS"
	MinOS="000"
fi

Patched=""
Extras=""
ExtrasMatos=""
ExtrasInApp=""
ExtrasAlsr=""

# Does it need at least an iPhone3GS ?
Required=$(plutil -key 'UIRequiredDeviceCapabilities' "$tempLoc/Info.plist" 2> /dev/null)
if [ ! -z "$(echo "$Required" | grep -e "armv7" -e "opengles-2")" ]; then
	ExtrasMatos=" 3GS"
fi

# Is it iPad compatible only ?
iPad=$(plutil -key 'UIDeviceFamily' "$tempLoc/Info.plist" 2> /dev/null)
if [ ! -z "$iPad" ]; then
	if [ -z "$(echo "$iPad" | grep -e "1")" ]; then
		ExtrasMatos=" iPad"
	fi
fi

# Creating temporary directory
if [ $PCMverbose = "YES" ]; then
	echo -n "${Meter10}$MsgCreDire "
fi
WorkDir="/tmp/PCM-$(date +%Y%m%d-%H%M%S)"
NewAppDir="$HOME/Documents/iNalyze"
if [ -e "$WorkDir" ]; then
	rm -rf "$WorkDir"
fi
mkdir -p "$WorkDir"
if [ ! -e "$NewAppDir" ]; then
	mkdir -p "$NewAppDir"
fi
mkdir -p "$WorkDir/$AppName"
if [ ! -d "$WorkDir" -o ! -d "$NewAppDir" -o ! -d "$WorkDir/$AppName" ]; then
	echo "failed ! Directories not created"
	return 1
fi

# Copying executable to temporary space
if [ $PCMverbose = "YES" ]; then
	echo "${Meter15}$MsgCopExec"
fi

foo=$( cp -a "$AppPath/$AppName/$AppExec" "$WorkDir/$AppName/" 2>&1> /dev/null )
if [ ! -e "$WorkDir/$AppName/$AppExec" ]; then
	echo "Unable to copy application files"
	rm -fr "$WorkDir"
	return 1
else
	# Disk full ?
	if [ $(stat -c%s "$WorkDir/$AppName/$AppExec") != $(stat -c%s "$AppPath/$AppName/$AppExec") ]; then
		echo "${escRed}$MsgDskFull ?${escReset}"
		rm -fr "$WorkDir"
		return 1
	fi
fi

if [ $PCMverbose = "YES" ]; then
	echo -n "${Meter20}$MsgAnaAppl: "
fi

# Can I haz kittenz ?
PawsPawsAttack="NO"

# Looking for fat's magic numbers (CafeBabe)
CafeBabeIsFat=$(dd bs=4 count=1 skip=0 if="$WorkDir/$AppName/$AppExec" 2> /dev/null | od -A n -t x1 -v | grep "ca fe ba be")
if [ ! "$CafeBabeIsFat" ]; then
	if [ $PCMverbose = "YES" ]; then
		echo "${Meter25}Thin Binary found"
	fi
	Iterations=1

	# Does it have the ASLR bit flag ?
	AslrBits=$(dd bs=1 count=1 skip=26 if="$WorkDir/$AppName/$AppExec" 2> /dev/null | od -A n -t u -v )
	AslrBit=$(( $AslrBits & 32 ))
	if [ $AslrBit -ne 0 ]; then
		NotAslrBits=$(( $AslrBits & 223 ))
		echo "${Meter26}${escYellow}Warning:${escReset} ASLR bit detected. Trying"
		PawsPawsAttack="YES"
	fi

else
	if [ $PCMverbose = "YES" ]; then
		echo "${Meter25}Fat Binary found"
		echo "${Meter26}Dumping armv6 section"
	fi

	# We don't use lipo anymore
	#foo=$(lipo -thin armv6 "$WorkDir/$AppName/$AppExec" -output "$WorkDir/$AppName/IWantYourSix" 2>&1> /dev/null)

	# Get the fat's full headers, then extract the infos
	foo=$(dd bs=4096 count=1 skip=0 if="$WorkDir/$AppName/$AppExec" of="$WorkDir/$AppName/CafeBabe.is.Fat" 2>&1> /dev/null)
	FullCafeBabe=$(cat "$WorkDir/$AppName/CafeBabe.is.Fat" | od -A n -t x1 -v | tr -d ' ','\n')
	SixOrNine=${FullCafeBabe:30:2}
	NineOrSix=${FullCafeBabe:70:2}
	if [ "$SixOrNine" = "06" ]; then
		SixSix=${FullCafeBabe:32:16}
	fi
	if [ "$SixOrNine" = "09" ]; then
		NineNine=${FullCafeBabe:32:16}
	fi
	if [ "$NineOrSix" = "06" ]; then
		SixSix=${FullCafeBabe:72:16}
	fi
	if [ "$NineOrSix" = "09" ]; then
		NineNine=${FullCafeBabe:72:16}
	fi
	SixOff=$(echo "0x${SixSix:0:8}" | awk --non-decimal-data '{print ($1)+1 }')
	SixSize=$(echo "0x${SixSix:8:8}" | awk --non-decimal-data '{print ($1)+0 }')
	NineOff=$(echo "0x${NineNine:0:8}" | awk --non-decimal-data '{print ($1)+1 }')
	NineSize=$(echo "0x${NineNine:8:8}" | awk --non-decimal-data '{print ($1)+0 }')
	# Cut the arm6 part from the fat binary
	foo=$( cat "$WorkDir/$AppName/$AppExec" | tail --bytes=+$SixOff | head --bytes=$SixSize > "$WorkDir/$AppName/IWantYourSix" 2> /dev/null )

	# Disk full ?
	if [ ! -e "$WorkDir/$AppName/IWantYourSix" ]; then
		echo "${escRed}$MsgDskFull ?${escReset}"
		rm -fr "$WorkDir"
		return 1
	else
		if [ $(stat -c%s "$WorkDir/$AppName/IWantYourSix") != $SixSize ]; then
			echo "${escRed}$MsgDskFull ?${escReset}"
			rm -fr "$WorkDir"
			return 1
		fi
	fi

	chmod 777 "$WorkDir/$AppName/IWantYourSix"

	# Does it have the ASLR bit flag ?
	AslrBits=$(dd bs=1 count=1 skip=26 if="$WorkDir/$AppName/IWantYourSix" 2> /dev/null | od -A n -t u -v )
	AslrBit=$(( $AslrBits & 32 ))
	if [ $AslrBit -ne 0 ]; then
		echo "${Meter26}${escRed}Warning:${escReset} ASLR bit detected. FAIL"
		rm -fr "$WorkDir"
		return 1
	fi

	# Force armv7 processing on armv6 devices. (It won't work at all; for debug only !)
	if [ $PCMarm7onarm6 = "YES" ]; then
		echo "${Meter27}${escYellow}Warning:${escReset} forcing armv7 is stupid !"
		CPUType=""
	else
		CPUType=$(sysctl hw.cpusubtype | grep 6 | awk '{print $2}')
	fi

	# The iDevice has an arm7 cpu
	if [ ! $CPUType ]; then
		if [ $PCMverbose = "YES" ]; then
			echo "${Meter28}Dumping armv7 section"
		fi
		Iterations=2
		# Swapping armv6 and armv7 headers
		SixOrNine=$(dd bs=1 count=1 skip=15 if="$WorkDir/$AppName/$AppExec" 2> /dev/null)
		NineOrSix=$(dd bs=1 count=1 skip=35 if="$WorkDir/$AppName/$AppExec" 2> /dev/null)
		foo=$(echo -n "$NineOrSix" | dd bs=1 seek=15 conv=notrunc status=noxfer of="$WorkDir/$AppName/$AppExec" 2>&1> /dev/null)
		foo=$(echo -n "$SixOrNine" | dd bs=1 seek=35 conv=notrunc status=noxfer of="$WorkDir/$AppName/$AppExec" 2>&1> /dev/null)

		# We don't use lipo anymore
		#foo=$(lipo -thin armv6 "$WorkDir/$AppName/$AppExec" -output "$WorkDir/$AppName/SevenTrumpets" 2>&1> /dev/null)

		# Dumping swapped armv7 part
		foo=$( cat "$WorkDir/$AppName/$AppExec" | tail --bytes=+$NineOff | head --bytes=$NineSize > "$WorkDir/$AppName/SevenTrumpets" 2> /dev/null )

		# Disk full ?
		if [ ! -e "$WorkDir/$AppName/SevenTrumpets" ]; then
			echo "${escRed}$MsgDskFull ?${escReset}"
			rm -fr "$WorkDir"
			return 1
		else
			if [ $(stat -c%s "$WorkDir/$AppName/SevenTrumpets") != $NineSize ]; then
				echo "${escRed}$MsgDskFull ?${escReset}"
				rm -fr "$WorkDir"
				return 1
			fi
		fi

		chmod 777 "$WorkDir/$AppName/SevenTrumpets"

		# Does it have the ASLR bit flag ?
		AslrBits=$(dd bs=1 count=1 skip=26 if="$WorkDir/$AppName/SevenTrumpets" 2> /dev/null | od -A n -t u -v )
		AslrBit=$(( $AslrBits & 32 ))
		if [ $AslrBit -ne 0 ]; then
			echo "${Meter28}${escYellow}Warning:${escReset} ASLR bit detected. Trying."
			NotAslrBits=$(( $AslrBits & 223 ))
			PawsPawsAttack="YES"
		fi

	else
		if [ $PCMverbose = "YES" ]; then
			echo "${Meter28}Non armv7 compatible CPU: not dumping armv7"
		fi
		# Forcing fat to thin
		Iterations=1
	fi
	# (Deleting the fat binary: later)
fi

# Doing one or two parts
for (( i=1;i<=$Iterations;i++)); do
	if [ ! "$CafeBabeIsFat" ]; then
		AppExecCur=$AppExec
	else
		if [ $i -eq 1 ]; then
			if [ $PCMverbose = "YES" ]; then
				echo "${Meter30}--- Cracking armv6 section ---"
			fi
			AppExecCur="IWantYourSix"
		else
			if [ $PCMverbose = "YES" ]; then
				echo "${Meter30}--- Cracking armv7 section ---"
			fi
			AppExecCur="SevenTrumpets"
		fi
	fi

	# Getting executable's details
	Peter=$(otool -l "$WorkDir/$AppName/$AppExecCur")

	# Check executable's dump address. Rare apps shift it on purpose.
	Pesky=$(echo "$Peter" | tr '\n' '\\' | sed -e 's:Load command:\nLoad command:g' | grep "cmd LC_SEGMENT" | grep "segname __TEXT" | tr '\\' '\n' | grep "vmaddr" | awk --non-decimal-data '{print ($2)+0 }')
	if [ $Pesky != 4096 ]; then
		echo "${Meter31}${escRed}Warning:${escReset} address shifting ($Pesky)"
	fi

	# Finding location of the "cstring" data block to be LamedPatched
	LPoff=$(echo "$Peter" | grep cstring -A4 | grep offset | awk '{print $2}')
	if [ ! "$LPoff" ]; then
		echo "${Meter31}${escYellow}Warning:${escReset} unable to find LPoff"
		LPoff=0
		LPsize=0
	else
		LPsize=$(echo "$Peter" | grep cstring -A4 | grep size | awk --non-decimal-data '{print ($2)+0 }')
		if [ ! "$LPsize" ]; then
			echo "${Meter31}${escYellow}Warning:${escReset} unable to find LPsize"
			LPoff=0
			LPsize=0
		fi
	fi

	# Finding all Crypt details
	CryptID=$(echo "$Peter" | grep cryptid | awk '{print $2}')
	if [ "$CryptID" != "1" ]; then
		echo "${escRed}Application is not encrypted - Running iNlayzer Packager${escReset}"
		export OrgDir=${WorkDir}
		export WorkDir="$HOME/Documents/iNalyze/$AppName"
		mkdir -p "$WorkDir/Payload/$AppName/" 
		cp $OrgDir/$AppName/$AppExec $WorkDir/Payload/$AppName/
		iNalyzer
		zip -r "$HOME/Documents/iNalyze/$AppName.zip" "$HOME/Documents/iNalyze/$AppName" 2>&1> /dev/null
		rm -fr "$WorkDir" 
		export WorkDir=${OrgDir}
		rm -fr "$WorkDir"
		echo "${Meter100}${escGreen}$MsgIpaDone${escReset} \"$HOME/Documents/iNalyze/$AppName.zip\" "
		return 0
	fi
	CryptSize=$(echo "$Peter" | grep cryptsize | awk '{print $2}')
	if [ ! "$CryptSize" ]; then
		echo "${escRed}Unable to find CryptSize${escReset}"
		rm -fr "$WorkDir"
		return 1
	fi
	CryptOff=$(echo "$Peter" | grep cryptoff | awk '{print $2}')
	if [ ! "$CryptOff" ]; then
		echo "${escRed}Unable to find CryptOff${escReset}"
		rm -fr "$WorkDir"
		return 1
	fi

	# This app has in-app purchases (aka DLC) ?
	if [ ! -z "$( dd bs=$CryptOff count=1 if="$WorkDir/$AppName/$AppExecCur" 2> /dev/null | grep "StoreKit.framework" )" ]; then
		ExtrasInApp=" InApp"
	fi

	# - Take first 4KB of the file (ie: headers), convert to hex on 1 long line
	# - Find the CryptID command block
	# - Compute the offset to patch
	# - Patch 01 --> 00
	if [ $PCMverbose = "YES" ]; then
		echo "${Meter32}$MsgPatCryp"
	fi
	dd bs=4096 count=1 if="$WorkDir/$AppName/$AppExecCur" 2> /dev/null | \
	od -A n -t x1 -v | \
	tr -d ' ','\n' | \
	sed "s/0000002100000014......................01.*/ThisIsItThisIsItThisIsItMichaelJackson/g" > "$WorkDir/hex.tmp"
	foo=$(echo -ne "\x00" | dd bs=1 seek=$(expr $(($(stat -c%s "$WorkDir/hex.tmp"))) / 2) conv=notrunc status=noxfer of="$WorkDir/$AppName/$AppExecCur" 2>&1> /dev/null)
	rm -f "$WorkDir/hex.tmp"
	cid=$(otool -l "$WorkDir/$AppName/$AppExecCur" | grep cryptid | awk '{print $2}')

	if [ "$cid" != "0" ]; then
		echo "${escRed}Unable to patch CryptID${escReset}"
		rm -fr "$WorkDir"
		return 1
	fi

	# Creating GDB script
	if [ $AltDump != "YES" ]; then
		echo -e "set sharedlibrary load-rules \".*\" \".*\" none\r\n\
		set inferior-auto-start-dyld off\r\n\
		set sharedlibrary preload-libraries off\r\n\
		set sharedlibrary load-dyld-symbols off\r\n\
		handle all nostop\r\n\
		rb doModInitFunctions\r\n
		command 1\r\n\
		dump memory $WorkDir/dump.bin $(($CryptOff + $Pesky)) $(($CryptSize + $CryptOff + $Pesky))\r\n\
		dump memory $WorkDir/LP.bin $(($LPoff + $Pesky)) $(($LPsize + $LPoff + $Pesky))\r\n\
		kill\r\n\
		quit\r\n\
		end\r\n\
		start" > $WorkDir/batch.gdb
	else
		echo -e "set sharedlibrary load-rules \".*\" \".*\" none\r\n\
		set inferior-auto-start-dyld off\r\n\
		set sharedlibrary preload-libraries off\r\n\
		set sharedlibrary load-dyld-symbols off\r\n\
		dump memory $WorkDir/dump.bin $(($CryptOff + $Pesky)) $(($CryptSize + $CryptOff + $Pesky))\r\n\
		dump memory $WorkDir/LP.bin $(($LPoff + $Pesky)) $(($LPsize + $LPoff + $Pesky))\r\n\
		quit\r\n" > $WorkDir/batch.gdb
	fi

	# If first part (arm6) of a fat binary and running an arm7 iDevice, swap trick !
	# (The arm7 iDevice always load the arm7 part, but it's swapped with the arm6 part: tricked).
	SwapSwapAttack="NO"
	if [ $i -eq 1 ]; then
		if [ "$CafeBabeIsFat" ]; then
			if [ ! $CPUType ]; then
				SwapSwapAttack="YES"
			fi
		fi
	fi

	if [ $PCMverbose = "YES" ]; then
		echo "${Meter40}$MsgDmpUncr"
	fi

	if [ $SwapSwapAttack = "YES" ]; then
		# Cracking the previously swapped fat binary in WorkDir
		if [ $PCMverbose = "YES" ]; then
			echo "${Meter41}Swap Swap Attack !"
		fi
		# Copying some files
		mkdir "$WorkDir/$AppName/SC_Info"
		chmod 777 "$WorkDir/$AppName/SC_Info"
		cp "$AppPath/$AppName/SC_Info/$AppExec.sinf" "$WorkDir/$AppName/SC_Info/$AppExec.sinf"
		chmod 777 "$WorkDir/$AppName/SC_Info/$AppExec.sinf"
		cp "$AppPath/$AppName/SC_Info/$AppExec.supp" "$WorkDir/$AppName/SC_Info/$AppExec.supp"
		chmod 777 "$WorkDir/$AppName/SC_Info/$AppExec.supp"

		# Cracking the previously swapped fat binary in WorkDir
		if [ $AltDump != "YES" ]; then
			DumpLog=$(gdb -q -e "$WorkDir/$AppName/$AppExec" -x $WorkDir/batch.gdb -batch 2>&1)
		else
			echo "${Meter41}Using alt dumping"
			echo "${Meter42}Running app in background"
			# Running executable in background with low priority.
			(nice "$WorkDir/$AppName/$AppExec" & echo $! > /tmp/pid.txt ) > /dev/null  2>&1> /dev/null
			# Get PID of this background process
			backback=$(cat /tmp/pid.txt)
			rm /tmp/pid.txt
			echo "${Meter43}Loading app in background"
			sleep 10
			if [ ! "$(ps -e | grep "$backback " | grep "$WorkDir/$AppName/$AppExec" | wc -l)" -eq 1 ]; then
				echo "Buah, buah, buah"
				rm -fr "$WorkDir"
				return 1
			fi
			echo "${Meter44}Attaching process $backback"
			DumpLog=$(gdb -q -x $WorkDir/batch.gdb -batch --pid=$backback  >&1  2>&1)
			sleep 1
			# Kill and wait...
			echo "${Meter45}Killing process $backback"
			kill $backback > /dev/null 2>&1
			sleep 1
			echo "${Meter46}Waiting for end of process $backback"
			wait $backback > /dev/null 2>&1
		fi

		# Removing temp files
		rm "$WorkDir/$AppName/$AppExec"
		rm "$WorkDir/$AppName/SC_Info/$AppExec.sinf"
		rm "$WorkDir/$AppName/SC_Info/$AppExec.supp"
		rmdir "$WorkDir/$AppName/SC_Info"
	else
		# Cracking genuine executable in AppPath
		if [ $AltDump != "YES" ]; then

			if [ $PawsPawsAttack = "YES" ]; then
				# Cracking the kittenz clawzed fat binary in WorkDir
				if [ $PCMverbose = "YES" ]; then
					echo "${Meter41}Paws Paws Attack ! Kittenz clawz !"
				fi

				# Copying some files
				mkdir "$WorkDir/ASLR"
				chmod 777 "$WorkDir/ASLR"
				mkdir "$WorkDir/ASLR/SC_Info"
				chmod 777 "$WorkDir/ASLR/SC_Info"
				cp "$AppPath/$AppName/SC_Info/$AppExec.sinf" "$WorkDir/ASLR/SC_Info/$AppExec.sinf"
				chmod 777 "$WorkDir/ASLR/SC_Info/$AppExec.sinf"
				cp "$AppPath/$AppName/SC_Info/$AppExec.supp" "$WorkDir/ASLR/SC_Info/$AppExec.supp"
				chmod 777 "$WorkDir/ASLR/SC_Info/$AppExec.supp"

				# Copying genuine executable then patching its ASLR bit
				cp "$AppPath/$AppName/$AppExec" "$WorkDir/ASLR/$AppExec"
				chmod 777 "$WorkDir/ASLR/$AppExec"

				# Computing where to patch
				if [ ! "$CafeBabeIsFat" ]; then
					BouncingTigger=26
				else
					BouncingTigger=$(($NineOff + 25))
				fi

				foo=$(echo $NotAslrBits | awk '{ printf("%c",$0); }' | \
					dd bs=1 seek=$BouncingTigger conv=notrunc status=noxfer of="$WorkDir/ASLR/$AppExec" 2>&1> /dev/null)

				# Gdbing it
				DumpLog=$(gdb -q -e "$WorkDir/ASLR/$AppExec" -x $WorkDir/batch.gdb -batch 2>&1)

				# Removing temp files
				rm "$WorkDir/ASLR/$AppExec"
				rm "$WorkDir/ASLR/SC_Info/$AppExec.sinf"
				rm "$WorkDir/ASLR/SC_Info/$AppExec.supp"
				rmdir "$WorkDir/ASLR/SC_Info"
				rmdir "$WorkDir/ASLR"

				ExtrasAlsr=" ASLR"

			else
				# Cracking genuine executable in AppPath
				DumpLog=$(gdb -q -e "$AppPath/$AppName/$AppExec" -x $WorkDir/batch.gdb -batch 2>&1)
			fi
		else
			# Alt-cracking genuine executable in AppPath
			echo "${Meter41}Using alt dumping"
			echo "${Meter42}Running app in background"
			# Running executable in background with low priority.
			(nice "$AppPath/$AppName/$AppExec" & echo $! > /tmp/pid.txt ) > /dev/null  2>&1> /dev/null
			# Get PID of this background process
			backback=$(cat /tmp/pid.txt)
			rm /tmp/pid.txt
			echo "${Meter43}Loading app in background"
			sleep 10
			if [ ! "$(ps -e | grep "$backback " | grep "$AppPath/$AppName/$AppExec" | wc -l)" -eq 1 ]; then
				echo "Buah, buah, buah"
				rm -fr "$WorkDir"
				return 1
			fi
			echo "${Meter44}Attaching process $backback"
			DumpLog=$(gdb -q -x $WorkDir/batch.gdb -batch --pid=$backback  >&1  2>&1)
			sleep 1
			# Kill and wait...
			echo "${Meter45}Killing process $backback"
			kill $backback > /dev/null 2>&1
			sleep 1
			echo "${Meter46}Waiting for end of process $backback"
			wait $backback > /dev/null 2>&1
		fi
	fi

	# Not needed anymore
	rm $WorkDir/batch.gdb

	# Verifying dump
	if [ $PCMverbose = "YES" ]; then
		echo -n "${Meter50}$MsgVrfDump "
	fi
	if [ ! -e "$WorkDir/dump.bin" ]; then
		echo "${escRed}failed ! Can't dump ?${escReset}"
		if [ -e /usr/bin/logger ]; then
			echo "$DumpLog" | logger -t PCMdump
		fi
		rm -fr "$WorkDir"
		return 1
	fi
	DumpSize=$(stat -c%s "$WorkDir/dump.bin")
	if [ "$DumpSize" != "$CryptSize" ]; then
		echo "${escRed}failed ! Wrong dump size ?${escReset}"
		if [ -e /usr/bin/logger ]; then
			echo "$DumpLog" | logger -t PCMdump
		fi
		rm -fr "$WorkDir"
		return 1
	fi

	# Replacing executable's crypted data with dumped clear data
	if [ $PCMverbose = "YES" ]; then
		echo "${Meter54}$MsgRepData"
	fi
	foo=$(dd seek=1 count=1 obs=$CryptOff ibs=$DumpSize conv=notrunc if="$WorkDir/dump.bin" of="$WorkDir/$AppName/$AppExecCur" 2>&1> /dev/null)
	rm "$WorkDir/dump.bin"

	# Trying LamestPatchest to remove some ads and some security checks
	if [ $PCMlamestpatchest = "YES" ]; then
		if [ $LPoff = 0 -o $LPsize = 0 ]; then
			patchme="$WorkDir/$AppName/$AppExecCur"
			if [ $PCMverbose = "YES" ]; then
				echo -n "${Meter58}${escYellow}Trying old LamerPatcher...${escReset} "
			fi
		else
			patchme="$WorkDir/LP.bin"
			if [ $PCMverbose = "YES" ]; then
				echo -n "${Meter58}Trying LamestPatchest... "
			fi
			# Disk full ?
			if [ $(stat -c%s "$WorkDir/LP.bin") != $LPsize ]; then
				echo "${escRed}$MsgDskFull ?${escReset}"
				rm -fr "$WorkDir"
				return 1
			fi
		fi
		# LamingPatching ! Disabled by iNaliyzer mod remove double ## to enable
		##sed --in-place=.BCK \
		##	-e 's=/Cydia\.app=/Czdjb\.bpp=g' \
		##	-e 's=ppa\.aidyC=ppb\.bjdzC=g' \
		##	-e 's=/private/var/lib/apt=/prjvbtf/vbr/ljb/bpt=g' \
		##	-e 's=/bin/mkdir=/bjn/mkdjr=g' \
		##	-e 's=/usr/bin/ssh=/vsr/bjn/ssh=g' \
		##	-e 's=/Applicat\d0\d0\d0ions/dele\d0\d0\d0teme\.txt=/Bppljcbt\d0\d0\d0jpns/dflf\d0\d0\d0tfmf\.txt=g' \
		##	-e 's=/Appl\d0\d0\d0ications/C\d0\d0ydi\d0a\.app=/Bppl\d0\d0\d0jcbtjpns/C\d0\d0zdj\d0b\.bpp=g' \
		##	-e 's=ations/Cy\d0\d0\d0/Applic\d0pp\d0\d0dia.a=btjpns/Cz\d0\d0\d0/Bppljc\d0pp\d0\d0djb.b=g' \
		##	-e 's=ate/va\d0\d0/priv\d0\d0\d0pt/\d0b/a\d0r/li=btf/vb\d0\d0/prjv\d0\d0\d0pt/\d0b/b\d0r/lj=g' \
		##	-e 's=pinchmedia\.com=pjnchmfdjb\.cpm=g' \
		##	-e 's=admob\.com=bdmpb\.cpm=g' \
		##	-e 's=doubleclick\.net=dpvblfcljck\.nft=g' \
		##	-e 's=googlesyndication\.com=gppglfszndjcbtjpn\.cpm=g' \
		##	-e 's=flurry\.com=flvrrz\.cpm=g' \
		##	-e 's=qwapi\.com=qwbpj\.cpm=g' \
		##	-e 's=mobclix\.com=mpbcljx\.cpm=g' \
		##	-e 's=http://ad\.=http://bd/=g' \
		##	-e 's=http://ads\.=http://bds/=g' \
		##	-e 's=http://ads2\.=http://bds2/=g' \
		##	-e 's=adwhirl\.com=bdwhjrl\.cpm=g' \
		##	-e 's=vdopia\.com=vdppjb\.cpm=g' \
		##	-e 's=tapjoyads\.com=tbpjpzbds\.cpm=g' \
		##	-e 's=/Library/MobileSubstrate=/Ljbrbrz/MpbjlfSvbstrbtf=g' \
		##	"$patchme"

		#	"/Applications/mAdvLock.app"
		#	"/Applications/Icy\.app"
		#	"/Applications/SBSettings\.app"

		# Disk full ?
		if [ ! -e "$patchme.BCK" ]; then
			echo "${escRed}$MsgDskFull ?${escReset}"
			rm -fr "$WorkDir"
			return 1
		else
			if [ $(stat -c%s "$patchme.BCK") != $(stat -c%s "$patchme") ]; then
				echo "${escRed}$MsgDskFull ?${escReset}"
				rm -fr "$WorkDir"
				return 1
			fi
		fi

		# Something patched or not ?
		cmp --silent "$patchme.BCK" "$patchme"
		if [ "$?" != "0" ]; then
			if [ $PCMverbose = "YES" ]; then
				echo "${Meter59}patched things"
			fi
			Patched=" LP"
			if [ -e "$WorkDir/LP.bin" ]; then
				foo=$(dd seek=1 count=1 obs=$LPoff ibs=$LPsize conv=notrunc if="$WorkDir/LP.bin" of="$WorkDir/$AppName/$AppExecCur" 2>&1> /dev/null)
			fi
		else
			if [ $PCMverbose = "YES" ]; then
				echo "${Meter59}found nothing"
			fi
		fi
		rm "$patchme.BCK"
	fi
	if [ -e "$WorkDir/LP.bin" ]; then
		rm "$WorkDir/LP.bin"
	fi
done
# End of loop. All parts are now done.

# Unsplitting fat binary
if [ "$CafeBabeIsFat" ]; then
	rm -f "$WorkDir/$AppName/$AppExec"
	if [ $PCMverbose = "YES" ]; then
		echo "${Meter61}---"
	fi
	if [ -e "$WorkDir/$AppName/SevenTrumpets" ]; then
		if [ $PCMverbose = "YES" ]; then
			echo "${Meter62}$MsgComBoth"
		fi

		# We don't use lipo anymore
		#foo=$(lipo -create "$WorkDir/$AppName/IWantYourSix" "$WorkDir/$AppName/SevenTrumpets" -output "$WorkDir/$AppName/$AppExec" 2>&1> /dev/null)

		if [ $NineOff -gt $SixOff ]; then
			foo=$( cat "$WorkDir/$AppName/CafeBabe.is.Fat" "$WorkDir/$AppName/IWantYourSix" /dev/zero | head --bytes=$(($NineOff - 1)) > "$WorkDir/$AppName/TaSoeurEstGrosse"  2> /dev/null )
			foo=$( cat "$WorkDir/$AppName/TaSoeurEstGrosse" "$WorkDir/$AppName/SevenTrumpets" > "$WorkDir/$AppName/$AppExec"  2> /dev/null )
			rm -f "$WorkDir/$AppName/TaSoeurEstGrosse"
		else
			echo "${Meter64}Warning: Six ($SixOff) is bigger ($NineOff)"
			foo=$( cat "$WorkDir/$AppName/CafeBabe.is.Fat" "$WorkDir/$AppName/SevenTrumpets" /dev/zero | head --bytes=$(($SixOff - 1)) > "$WorkDir/$AppName/TaSoeurEstGrosse"  2> /dev/null )
			foo=$( cat "$WorkDir/$AppName/TaSoeurEstGrosse" "$WorkDir/$AppName/IWantYourSix" > "$WorkDir/$AppName/$AppExec"  2> /dev/null )
			rm -f "$WorkDir/$AppName/TaSoeurEstGrosse"
		fi
		rm "$WorkDir/$AppName/IWantYourSix"
		rm "$WorkDir/$AppName/SevenTrumpets"
		# Disk full ?
		if [ $(stat -c%s "$WorkDir/$AppName/$AppExec") != $(stat -c%s "$AppPath/$AppName/$AppExec") ]; then
			echo "${escRed}$MsgDskFull ?${escReset}"
			rm -fr "$WorkDir"
			return 1
		fi
	else
		mv "$WorkDir/$AppName/IWantYourSix" "$WorkDir/$AppName/$AppExec"
	fi

	# Disk full ?
	if [ ! -e "$WorkDir/$AppName/$AppExec" ]; then
		echo "${escRed}$MsgDskFull ?${escReset}"
		rm -fr "$WorkDir"
		return 1
	fi

	chmod 777 "$WorkDir/$AppName/$AppExec"

	# Dropping my girlfriend
	if [ -e "$WorkDir/$AppName/CafeBabe.is.Fat" ]; then
		rm -f "$WorkDir/$AppName/CafeBabe.is.Fat"
	fi
fi

# Signing the application with 'ldone' (better than 'ldid').
if [ $PCMverbose = "YES" ]; then
	echo "${Meter64}$MsgSgnAppl"
fi
foo=$(ldone "$WorkDir/$AppName/$AppExec" -s 2>&1> /dev/null)

# Timestamp-back executable to defeat checks
touch -r "$AppPath/$AppName/$AppExec" "$WorkDir/$AppName/$AppExec"

# Adding date
DayToday="$( date +%Y-%m-%d )"

# Adding credits file
if [ ! "$CrackerName" = "Anonymous" ]; then
	if [ $PCMverbose = "YES" ]; then
		echo "${Meter65}Adding Credits"
	fi
	echo "Cracked by $CrackerName ($DayToday)" > "$WorkDir/$AppName/$CreditFile"
	if [ ! -e "$AppPath/$AppName/$AppExec.crc" ]; then
		echo "CheckSum=$(echo -n "$CrackerName" | od -A n -t x1 -v | tr -d ' ','\n')" > "$WorkDir/$AppName/$AppExec.crc"
		touch -r "$AppPath/$AppName/$AppExec" "$WorkDir/$AppName/$AppExec.crc"
	fi
fi


# Building .ipa (step 1)
mkdir -p "$WorkDir/Payload"
if [ ! -e "$WorkDir/Payload" ]; then
	echo "Failed to create Payload directory"
	rm -fr "$WorkDir"
	return 1
fi
mv "$WorkDir/$AppName" "$WorkDir/Payload/"


iNalyzer

if [ $PCMverbose = "YES" ]; then
	echo -n "${Meter68}$MsgCopArtw "
fi
if [ -e "$AppPath/iTunesArtwork" ]; then
	cp -a "$AppPath/iTunesArtwork" "$WorkDir/"
	# Timestamp ArtWork to protect cracker
	touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/iTunesArtwork"
else
	echo "${Meter68}failed !"
fi

# Handling of CodeResources and friends. Timestamp them to protect cracker
cp -a "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/Info.plist"
mkdir "$WorkDir/Payload/$AppName/_CodeSignature"
d=$( cp "$AppPath/$AppName/CodeResources" "$WorkDir/Payload/$AppName/_CodeSignature/CodeResources" 2>/dev/null)
ln -s "_CodeSignature/CodeResources" "$WorkDir/Payload/$AppName/CodeResources"
if [ -e "$AppPath/$AppName/ResourceRules.plist" ]; then
	cp "$AppPath/$AppName/ResourceRules.plist" "$WorkDir/Payload/$AppName/ResourceRules.plist"
	touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/ResourceRules.plist"
fi
touch -h -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/CodeResources"
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/_CodeSignature/CodeResources"
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName/_CodeSignature"

# Faking MetaData
if [ $PCMverbose = "YES" ]; then
	if [ $PCMmetadata = "YES" ]; then
		echo "${Meter69}$MsgFakMeta"
	else
		echo "${Meter69}$MsgNotMeta"
	fi
fi
if [ "$CrackerName" = "Anonymous" ]; then
	CrackedBy="Timothy.D.Cook@apple.com"
else
	CrackedBy="$CrackerName@cracked.by"
fi
cp "$AppPath/iTunesMetadata.plist" "$WorkDir/iTunesMetadataSource.plist"
# Convert to pure text (if binary plist)
plutil -xml "$WorkDir/iTunesMetadataSource.plist" 2>&1> /dev/null
# Remove unwanted key and subkeys
plutil -remove -key 'com.apple.iTunesStore.downloadInfo' "$WorkDir/iTunesMetadataSource.plist" 2>&1> /dev/null
# Building lines
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$WorkDir/iTunesMetadata.plist"
echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> "$WorkDir/iTunesMetadata.plist"
echo "<plist version=\"1.0\">" >> "$WorkDir/iTunesMetadata.plist"
echo "<dict>" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>UIRequiredDeviceCapabilities</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</dict>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<key>appleId</key>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<string>$CrackedBy</string>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<key>purchaseDate</key>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "\t<date>2011-10-10T10:10:10Z</date>" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>artistId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>artistName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>bundleShortVersionString</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>bundleVersion</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>buy-only</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>buyParams</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>copyright</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>drmVersionNumber</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>fileExtension</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>gameCenterEnabled</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>gameCenterEverEnabled</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 -m1 "<key>genre</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 -m1 "<key>genreId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>itemId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>itemName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>kind</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>playlistArtistName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>playlistName</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>price</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>priceDisplay</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>rating</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</dict>" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>releaseDate</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>s</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareIcon57x57URL</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareIconNeedsShine</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>softwareSupportedDeviceIds</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</array>" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareVersionBundleId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>softwareVersionExternalIdentifier</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>softwareVersionExternalIdentifiers</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</array>" >> "$WorkDir/iTunesMetadata.plist"
grep -A99 "<key>subgenres</key>" "$WorkDir/iTunesMetadataSource.plist" | grep -m1 -B99 "</array>" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>vendorId</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
grep -A1 "<key>versionRestrictions</key>" "$WorkDir/iTunesMetadataSource.plist" >> "$WorkDir/iTunesMetadata.plist"
echo "</dict>" >> "$WorkDir/iTunesMetadata.plist"
echo -e "</plist>\n" >> "$WorkDir/iTunesMetadata.plist"
# Timestamp Metadata to protect cracker
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/iTunesMetadata.plist"

# Check for possible iTunesMetadata format changes
rm -f /tmp/diff.txt
diff "$WorkDir/iTunesMetadataSource.plist" "$WorkDir/iTunesMetadata.plist" > /tmp/diff.txt
rm -f "$WorkDir/iTunesMetadataSource.plist"
NewFields=$(wc -l /tmp/diff.txt | cut -f 1 -d " ")
if [ $NewFields -ne "11" -a $NewFields -ne "7" ]; then
	echo "${Meter70}${escYellow}$MsgWrnMeta ?${escReset}"
	#BEGIN DEBUG
	#echo "( $NewFields )"
	#cat /tmp/diff.txt
	#END DEBUG
fi
rm -f /tmp/diff.txt

# Don't want MetaData ? Keeping a backup
if [ ! $PCMmetadata = "YES" ]; then
	mv "$WorkDir/iTunesMetadata.plist" "$WorkDir/iTunesMetadata.backup.plist"
fi

# Want Extras in filename ?
if [ $PCMextras = "YES" ]; then
	Extras="$ExtrasMatos$ExtrasInApp"
fi

# Building IPA name, adding AppVersion and MinOsVersion, adding CrackerName
if [ "$CrackerName" = "Anonymous" ]; then
	CrackedBy=""
	ZipComment="25Lb9 ($DayToday)"
else
	CrackedBy="-$CrackerName"
	ZipComment="From $CrackerName with 25Lb9 ($DayToday)"
fi

 IPAName="$NewAppDir/$AppDisplayName (v$AppVer$ExtrasAlsr$Extras$Patched os$MinOS)$CrackedBy.Lb9.ipa"
#IPAName="$NewAppDir/$(echo -n "$AppDisplayName" | tr " " ".")-v$AppVer$CrackedBy.ipa"

# If debug-check-only, don't create Ipa
if [ $PCMcheck = "YES" ]; then
	touch "$IPAName.checked"
	echo "${Meter100}${escGreen}Check:${escReset} $AppDisplayName (v$AppVer$ExtrasAlsr$Extras$Patched os$MinOS)."
	rm -fr "$WorkDir"
	echo "$tempLoc" >> /var/mobile/.cracked.log
	MenuOK=$(($MenuOK + 1))
	return 0
fi

#DEBUG
#FreeSize=$(df -m "$NewAppDir/" | grep disk | awk '{print $4}')
#echo "${Meter74}Debug: free size on device    [$FreeSize M$MsgSizUnit]"
#DEBUG

# Size of first data to compress
FirstSize=$(du -m -s "$WorkDir" | cut -f 1)
echo "${Meter75}$MsgZipStep 1) [$FirstSize M$MsgSizUnit]"

# Timestamping
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload/$AppName"
touch -r "$AppPath/$AppName/Info.plist" "$WorkDir/Payload"

cd "$WorkDir"
rm -f "$IPAName"
# Script version number in zip's comment
# Faster ipa thanks to smart files order (?)
ZipError=$( echo "$ZipComment" | zip $PCMcompression -z -y -m -r "$IPAName" "Payload/$AppName/Info.plist" iTunesMetadata.plist iTunesArtwork Payload  2>&1> /dev/null )
#DEBUG: unzip -l "$IPAName"
cd "$PwdPwd" 2>&1> /dev/null

if [ ! -z "$ZipError" ]; then
	echo "${Meter76}${escRed}ZipError${escReset}: \"$( echo "$ZipError" | tr -d "\t\n" )\""
fi

if [ ! -e "$IPAName" ]; then
	echo "${escRed}Failed to compress the .ipa${escReset}"
	rm -fr "$WorkDir"
	return 1
fi

# Remember size of .ipa after step 1
ZipSize=$(stat -c%s "$IPAName")

# Building .ipa (step 2)
# Using a SymbolicLink pointing to App Directory
ln -s "$AppPath/" "$WorkDir/Payload"

#DEBUG
#FreeSize=$(df -m "$NewAppDir/" | grep disk | awk '{print $4}')
#echo "${Meter74}Debug: free size on device    [$FreeSize M$MsgSizUnit]"
#DEBUG

# Size of other data to compress
SecondSize=$(du -m -s "$AppPath" | cut -f 1)
echo "${Meter80}$MsgZipStep 2) [$(expr $SecondSize - $FirstSize) M$MsgSizUnit]"

cd "$WorkDir"
# Zip doesn't move/delete source, and excludes some unwanted files. Smart "-n" flag excludes already compact files.
ZipError=$( zip $PCMcompression -u -y -r -n .jpg:.JPG:.jpeg:.png:.PNG:.gif:.GIF:.Z:.gz:.zip:.zoo:.arc:.lzh:.rar:.arj:.mp3:.mp4:.m4a:.m4v:.ogg:.ogv:.avi:.flac:.aac \
	"$IPAName" Payload/* -x Payload/iTunesArtwork Payload/iTunesMetadata.plist "Payload/Documents/*" "Payload/Library/*" "Payload/tmp/*" "Payload/$AppName/$AppExec" "Payload/$AppName/SC_Info/*" "Payload/$AppName/_CodeSignature/*" "Payload/$AppName/CodeResources" "Payload/$AppName/ResourceRules.plist" "Payload/$AppName/Info.plist" 2>&1> /dev/null )
## */

if [ ! -z "$ZipError" ]; then
	echo "${Meter81}${escRed}ZipError${escReset}: \"$( echo "$ZipError" | tr -d "\t\n" )\""
fi

# It failed because disk is full (zip size after part2 is still the same)
if [ $(stat -c%s "$IPAName") -eq $ZipSize ]; then
	echo "${escRed}$MsgIpaInco ! $MsgDskFull ?${escReset}"
	rm -f "$IPAName"
	rm -fr "$WorkDir"
	return 1
fi

# Removing SymbolicLink
rm "$WorkDir/Payload"
cd "$PwdPwd" 2>&1> /dev/null

# Removing temporary directory
if [ $PCMverbose = "YES" ]; then
	echo "${Meter98}$MsgRemTemp"
fi
rm -rf "$WorkDir"

# Cracked app is added into the already-cracked apps list
echo "$tempLoc" >> /var/mobile/.cracked.log

# Cracked app is added into Crackulous' cracked-apps-ready-to-upload list
p="/private/var/root/Documents/IPAStore.plist"
if [ -e "$p" ]; then
	#If Crackulous is running, we must close it first
	Killous=$(ps -e | grep "/Applications/Crackulous" | grep -v "grep" | awk '{print $1}')
	if [ "$Killous" ]; then
		echo "${Meter99}Warning: killing Crackulous softly"
		kill $Killous
		sleep 1
	fi
	plutil -key "$IPAName" -type int -value "$(plutil -key 'itemId' "$AppPath/iTunesMetadata.plist" 2> /dev/null)" "$p" 2>&1> /dev/null
fi

# Displaying finished Ipa details
ZipSize=$(du -m -s "$IPAName" | cut -f 1)
echo "${Meter100}${escGreen}$MsgIpaDone${escReset} \"$IPAName\" [$ZipSize M$MsgSizUnit]"

MenuOK=$(($MenuOK + 1))
}

# End Core Function
# ======



# ======
# Begin script main part

# Origin's directory
PwdPwd="$PWD"

# Select texts' language
SelectLanguage

# Votez Martine !
if [ ! -e /bin/ps ]; then
	echo "$MsgCntFind 'ps'. $MsgInsCydi: 'adv-cmds'"
	exit 1
fi

# Is this script running inside a GUI ?
# (ie: parent process runs from "/Applications/xxx.app")
if [ ! "$(ps -e | grep "$PPID" | grep "/Applications/.*\.app/")" = "" ]; then
	PCMinaGUI="YES"
fi

# Initialize progress meter labels (for GUI)
if [ $PCMinaGUI = "YES" ]; then
	export TERM="xterm"
	for ((i=0;i<=100;i++)); do
		export Meter$i="$i% "
	done
else
	# Not GUI
	clear
	# Escape codes
	esc="$( echo -e -n "\033" )"
	escReset="${esc}[0m"
	escUnder="${esc}[4m"
	escBlue="${esc}[34m"
	escGreen="${esc}[32m"
	escRed="${esc}[31m"
	escYellow="${esc}[33m"
	escPurple="${esc}[35m"
	escCyan="${esc}[36m"

	# Terminal misconfigured
	if [ -z "$TERM" ]; then
		echo "${escYellow}Warning:${escReset} your \$TERM is not set"
		export TERM="xterm"
	fi

	# Screen width
	if [ ! -e /usr/bin/tput ]; then
		echo "$MsgCntFind 'tput'"
		exit 1
	fi
	Cols=$(tput cols)

	# Progress bars full width
	BarCols=$(( $Cols - 8 ))
	while [ ${#PCMxxx} -lt $BarCols ]
	do
		PCMxxx="$PCMxxx$PCMxxx"
		PCMsss="$PCMsss$PCMsss"
	done
fi

echo "${Meter0}       *** ${escUnder}iNalyzer-Packager v1.0b (based on PoedCrackMod v2.5.Lb9)${escReset} ***"

if [ ! -e /usr/bin/plutil ]; then
	echo "$MsgCntFind 'plutil'. $MsgInsCydi: 'Erica Utils'"
	exit 1
fi

if [ ! -e /usr/bin/gdb ]; then
	echo "$MsgCntFind 'gdb'. $MsgInsCydi: 'GNU Debugger'"
	exit 1
fi

if [ ! -e /usr/bin/otool ]; then
	echo "$MsgCntFind 'otool'. $MsgInsCydi: 'Darwin CC Tools'"
	exit 1
fi

#if [ ! -e /usr/bin/ldid ]; then
#	echo "$MsgCntFind 'ldid'. $MsgInsCydi: 'Link Identity Editor'"
#	exit 1
#fi
if [ ! -e /usr/bin/ldone ]; then
	echo "$MsgCntFind 'ldone'. $MsgInsCydi"
	exit 1
fi

if [ ! -e /bin/touch ]; then
	echo "$MsgCntFind 'touch'"
	exit 1
fi

# We don't use lipo anymore. Lipo sucks.
#if [ ! -e /usr/bin/lipo ]; then
#	echo "$MsgCntFind 'lipo'. $MsgInsCydi: 'Darwin CC Tools'"
#	exit 1
#fi

if [ ! -e /usr/bin/zip ]; then
	echo "$MsgCntFind 'zip'"
	exit 1
fi

if [ ! -e /usr/sbin/sysctl ]; then
	echo "$MsgCntFind 'sysctl'"
	exit 1
fi

if [ ! -e /usr/bin/basename ]; then
	echo "$MsgCntFind 'basename'"
	exit 1
fi

if [ ! -e /usr/bin/cut ]; then
	echo "$MsgCntFind 'cut'"
	exit 1
fi

if [ ! -e /usr/bin/awk ]; then
	echo "$MsgCntFind 'awk'. $MsgInsCydi: 'Gawk'"
	exit 1
fi

# Cydia's "speak" tool is needed for speech support
if [ ! -e /usr/bin/speak ]; then
	PCMspeak="NO"
fi

if [ ! -e /usr/bin/head ]; then
	echo "$MsgCntFind 'head'"
	exit 1
fi

if [ ! -e /usr/bin/tail ]; then
	echo "$MsgCntFind 'tail'"
	exit 1
fi

# Create an empty public memory file
if [ ! -e /var/mobile/.cracked.log ]; then
	touch /var/mobile/.cracked.log
	chmod 666 /var/mobile/.cracked.log
fi

AltDump="NO"

if [ ! $PCMinaGUI = "YES" ]; then
	# Get and store the encrypted apps list
	rm -f /tmp/lsd.tmp

	# Why is that slower than next code ???
	#ls -d /var/mobile/Applications/*/*.app/SC_Info 2> /dev/null | sort -f -t \/ -k 6 | while read OneApp
	## */
	#do
	#	echo "$(dirname "$OneApp")" >> /tmp/lsd.tmp
	#done

	# Why is that faster than previous code ???
	ls -d /var/mobile/Applications/*/*.app 2> /dev/null | sort -f -t \/ -k 6 | while read OneApp
	## */
	do
		if [ -d "$OneApp/SC_Info" ]; then
			echo "$OneApp" >> /tmp/lsd.tmp
		fi
	done

	# Secret "alternative dumping" flag
	if [ "$1" = "-a" ]; then
		shift
		echo "$MsgAltMeth"
		if [ ! -e /usr/bin/nice ]; then
			echo "$MsgCntFind 'nice'"
			rm -f /tmp/lsd.tmp
			exit 1
		fi
		AltDump="YES"
	fi

	if [ "$1" = "-v" ]; then
		shift
		PCMverbose="YES"
	fi

	# Secret "check only" flag
	if [ "$1" = "-chk" ]; then
		shift
		PCMcheck="YES"
	fi

	# No more argument: display help
	if [ $# -lt 1 ]; then
		# The "-a" flag is not displayed in the help, but it does exist.
		scr=$(basename $0)
		echo "List/Help: $scr"
		echo "	   Menu: $scr [-v] -m [CN [CFN]]"
		echo " CrackAll: $scr [-v] -all [CN [CFN]]"
		echo " CrackOne: $scr [-v] AN [CN [CFN]]"
		echo " MarkDone: $scr -mark"
		echo "ResetDone: $scr -zero"
		echo
		echo "AN=AppName CN=CrackerName CFN=CreditFileName"
		echo
		if [ -e /tmp/lsd.tmp ]; then
			cat /tmp/lsd.tmp | cut -f 6 -d '/' | sed "s:\\.app:,:" | tr "\n" " "
			echo -e "\010\010."
			rm -f /tmp/lsd.tmp
		fi
		exit 1
	fi

	# Erasing memory file
	if [ "$1" = "-zero" ]; then
		echo "$MsgEraMemo"
		# Don't use rm
		cp /dev/null /var/mobile/.cracked.log 2>&1> /dev/null
		rm -f /tmp/lsd.tmp
		exit 1
	fi

	# Marking all apps as done in memory file
	if [ "$1" = "-mark" ]; then
		echo "$MsgMrkDone"
		if [ -e /tmp/lsd.tmp ]; then
			cp /tmp/lsd.tmp /var/mobile/.cracked.log 2>&1> /dev/null
			rm -f /tmp/lsd.tmp
		else
			cp /dev/null /var/mobile/.cracked.log 2>&1> /dev/null
		fi
		exit 1
	fi

	MenuAsked=0
	MenuFound=0
	MenuOK=0
	MenuError=0
	MenuErrorList=""

	# Berzerk mode: cracking all apps
	if [ "$1" = "-all" ]; then
		echo -n "$MsgBrzMode !"
		if [ -e /tmp/lsd.tmp ]; then
			# ("grep -vf" is sloooow. Use "-Fvf")
			# Removing already-done from full apps list
			tempgrep=$(mktemp)
			grep -Fvf /var/mobile/.cracked.log /tmp/lsd.tmp > $tempgrep
			MenuAsked=$(cat $tempgrep | wc -l)
			ProgressTarget=$MenuAsked
			ProgressDone=0
			echo " ($MenuAsked)"
			echo

			if [ $PCMbarSize = "YES" -a $MenuAsked != 0 ]; then
				ProgressTargetSize=0
				ProgressDoneSize=0
				echo -n "Computing total size"
				# (Don't use a pipe for the while loop)
				while read OneApp
				do
					# Size of the app, till dawn.
					AppSize=$( du -s -k "$OneApp" | cut -f 1 )
					ProgressTargetSize=$(($ProgressTargetSize + $AppSize))
					echo -n "."
				done < $tempgrep
				echo
				echo
			fi

			# (Don't use a pipe for the while loop)
			while read OneApp
			do
				ProgressDone=$(($ProgressDone + 1))
				echo -n "${escPurple}($ProgressDone/$ProgressTarget)${escReset} "

				if [ $PCMbarSize = "YES" ]; then
					# Size of the app, till dawn.
					AppSize=$( du -s -k "$OneApp" | cut -f 1 )
					ProgressDoneSize=$(($ProgressDoneSize + $AppSize))
				fi

				CoreFunction "$OneApp" "$2" "$3"
				if [ $? = 1 ]; then
					if [ $PCMspeak = "YES" ]; then
						speak "Error !" &
					fi
					MenuError=$(($MenuError + 1))
					if [ -z "$MenuErrorList" ]; then
						MenuErrorList="${OneApp:62:$(( ${#OneApp} - 66 ))}"
					else
						MenuErrorList="$MenuErrorList, ${OneApp:62:$(( ${#OneApp} - 66 ))}"
					fi
				fi

				DisplayBars
				echo
			done < $tempgrep
			rm -f $tempgrep
			rm -f /tmp/lsd.tmp
		else
			echo " ($MsgBrzNoth)"
		fi

		echo "$MsgWasAskd:all ($MenuAsked)  $MsgFoundIt:$MenuFound  $MsgErrrors:$MenuError  OK:$MenuOK."
		if [ ! -z "$MenuErrorList" ]; then
			echo "$MsgErrrors: $MenuErrorList."
		fi

		if [ $PCMspeak = "YES" ]; then
			speak "Terminated." &
		fi

		exit 1
	else
		# Menu mode: displaying menu and processing user choices
		if [ "$1" = "-m" ]; then
			if [ -e /tmp/lsd.tmp ]; then
				rm -f /tmp/lsdmenu.tmp
				touch /tmp/lsdmenu.tmp
				rm -f /tmp/lsddisp.tmp
				# Array with all the letters
				Letters=( $( echo {a..z} {a..z}{a..z} ) )
				# Search for best columns size
				BestFiller=666
				BestFound=666
				for (( i=18;i<=30;i++)); do
					FillerFound=$(( $Cols % $i ))
					if [ $FillerFound -lt $BestFiller ]; then
						BestFiller=$FillerFound
						BestFound=$i
						if [ $FillerFound = 0 ]; then
							break
						fi
					fi
				done
				LongNames=$(( $BestFound - 3 ))
				ShortNames=$(( $LongNames - 1 ))

				echo -n "$MsgBldMenu"
				Letter=0
				LineLength=$Cols
				# ("grep -vf" is sloooow. Use "-Fvf")
				# Removing already-done from full apps list
				grep -Fvf /var/mobile/.cracked.log /tmp/lsd.tmp | while read OneApp
				do
					GoodLetter=${Letters[$Letter]}
					OneOneApp="${OneApp:62:$(( ${#OneApp} - 66 ))}$PCMdots"
					if [ $Letter -lt 26 ]; then
						echo -n "${escPurple}$GoodLetter:${escReset}${OneOneApp:0:$LongNames} " >> /tmp/lsddisp.tmp
						echo "\"$GoodLetter\"$OneApp" >> /tmp/lsdmenu.tmp
						LineLength=$(( $LineLength - $LongNames - 3 ))
					else
						echo -n "${escPurple}$GoodLetter:${escReset}${OneOneApp:0:$ShortNames} " >> /tmp/lsddisp.tmp
						echo "\"$GoodLetter\"$OneApp" >> /tmp/lsdmenu.tmp
						LineLength=$(( $LineLength - $ShortNames - 4 ))
					fi

					# End of line
					if [ $LineLength = $BestFiller ]; then
						echo "" >> /tmp/lsddisp.tmp
						LineLength=$Cols
					fi

					Letter=$(($Letter + 1))
					# Too much apps (max is 27*26 = 702)
					if [ $Letter = 702 ]; then
						break
					fi
				done

				# Other options
				echo -n "${escPurple}0:${escReset}${MskZroDone:0:$LongNames} " >> /tmp/lsddisp.tmp
				echo -n "${escPurple}9:${escReset}${MsgMrkDone:0:$LongNames} " >> /tmp/lsddisp.tmp

				# Displaying menu
				if [ -e /tmp/lsddisp.tmp ]; then
					echo
					clear
					echo "	   *** ${escUnder}PoedCrackMod v2.5.Lb9 menu${escReset} ***"
					cat /tmp/lsddisp.tmp
					rm -f /tmp/lsddisp.tmp
					echo
					read -p "$MsgYouChoi ? " YourChoices
					echo
					ProgressTarget=$( echo $YourChoices | wc -w )
					ProgressDone=0

					if [ $PCMbarSize = "YES" -a $ProgressTarget != 0 ]; then
						ProgressTargetSize=0
						ProgressDoneSize=0
						echo -n "Computing total size"

						# Do all these choices
						for OneChoice in $YourChoices
						do
							if [ ! "$OneChoice" = "0" ]; then
								if [ ! "$OneChoice" = "9" ]; then
									tempLoc=$(grep -i "\"$OneChoice\"" /tmp/lsdmenu.tmp | cut -f 3 -d "\"")
									if [ ! -z "$tempLoc" ]; then
										AppCount=$(echo "$tempLoc" | wc -l)
										if [ $AppCount = 1 ]; then
											# Size of the app, till dawn.
											AppSize=$( du -s -k "$tempLoc" | cut -f 1 )
											ProgressTargetSize=$(($ProgressTargetSize + $AppSize))
											echo -n "."
										fi
									fi
								fi
							fi
						done
						echo
						echo

						# Nothing to do; no need for progress
						if [ $ProgressTargetSize = 0 ]; then
							PCMbarSize="ZERO"
						fi
					fi

					# Do all these choices
					for OneChoice in $YourChoices
					do
						ProgressDone=$(($ProgressDone + 1))
						echo -n "${escPurple}($ProgressDone/$ProgressTarget)${escReset} "
						MenuAsked=$(($MenuAsked + 1))
						if [ "$OneChoice" = "0" ]; then
							echo "$MsgEraMemo"
							# Don't use rm
							cp /dev/null /var/mobile/.cracked.log 2>&1> /dev/null
							MenuAsked=$(($MenuAsked - 1))
						else
							if [ "$OneChoice" = "9" ]; then
								echo "$MsgMrkDone"
								cp /tmp/lsd.tmp /var/mobile/.cracked.log 2>&1> /dev/null
								MenuAsked=$(($MenuAsked - 1))
							else
								tempLoc=$(grep -i "\"$OneChoice\"" /tmp/lsdmenu.tmp | cut -f 3 -d "\"")
								if [ -z "$tempLoc" ]; then
									echo "$MsgWrgChoi ($OneChoice)"
								else
									AppCount=$(echo "$tempLoc" | wc -l)
									if [ $AppCount = 1 ]; then

										if [ $PCMbarSize = "YES" ]; then
											# Size of the app, till dawn.
											AppSize=$( du -s -k "$tempLoc" | cut -f 1 )
											ProgressDoneSize=$(($ProgressDoneSize + $AppSize))
										fi

										CoreFunction "$tempLoc" "$2" "$3"
										if [ $? = 1 ]; then
											if [ $PCMspeak = "YES" ]; then
												speak "Error !" &
											fi
											MenuError=$(($MenuError + 1))
											if [ -z "$MenuErrorList" ]; then
												MenuErrorList="${tempLoc:62:$(( ${#tempLoc} - 66 ))}"
											else
												MenuErrorList="$MenuErrorList, ${tempLoc:62:$(( ${#tempLoc} - 66 ))}"
											fi
										fi
									else
										echo "$MsgBadChoi ($OneChoice = $AppCount)"
									fi
								fi
							fi
						fi

						DisplayBars
						echo

					done
					rm -f /tmp/lsdmenu.tmp

					if [ $PCMspeak = "YES" ]; then
						speak "Finished." &
					fi

					echo
					echo "$MsgWasAskd:$MenuAsked  $MsgFoundIt:$MenuFound  $MsgErrrors:$MenuError  OK:$MenuOK."
					if [ ! -z "$MenuErrorList" ]; then
						echo "${escRed}$MsgErrrors:${escReset} $MenuErrorList."
					fi
				else
					echo " $MsgMnuEmpt !"
				fi
				rm -f /tmp/lsd.tmp
			fi
			exit 1
		fi
	fi
fi


# Just one app to do
CoreFunction "$1" "$2" "$3"
#if [ $? = 1 ]; then
#	echo "Error: problem encountered."
#	exit 1
#fi

# Not needed anymore
rm -f /tmp/lsd.tmp


#
# The truth is I never left you. I kept my promise.
#
# Never gonna give you up, never gonna let you down, never gonna run around and desert you.
# Never gonna make you cry, never gonna say goodbye, never gonna tell a lie and hurt you.
#

#iNalyzer mi.py invocation
run=$(killall python & python /Applications/AppSecLabsiNalyzer.app/mi.py &)


#
# Thanks.
# Merci.
# Hontoni arigato.
#



