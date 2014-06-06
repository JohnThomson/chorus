#!/bin/bash
# server=build.palaso.org
# project=Chorus
# build=chorus-precise64-master Continuous
# root_dir=..
# $Id: 0b75ca980cea444bf053cfdd852cb3e370225ffe $

cd "$(dirname "$0")"

# *** Functions ***
force=0
clean=0

while getopts fc opt; do
case $opt in
f) force=1 ;;
c) clean=1 ;;
esac
done

shift $((OPTIND - 1))

copy_auto() {
if [ "$clean" == "1" ]
then
echo cleaning $2
rm -f ""$2""
else
where_curl=$(type -P curl)
where_wget=$(type -P wget)
if [ "$where_curl" != "" ]
then
copy_curl $1 $2
elif [ "$where_wget" != "" ]
then
copy_wget $1 $2
else
echo "Missing curl or wget"
exit 1
fi
fi
}

copy_curl() {
echo "curl: $2 <= $1"
if [ -e "$2" ] && [ "$force" != "1" ]
then
curl -# -L -z $2 -o $2 $1
else
curl -# -L -o $2 $1
fi
}

copy_wget() {
echo "wget: $2 <= $1"
f=$(basename $2)
d=$(dirname $2)
cd $d
wget -q -L -N $1
cd -
}


# *** Results ***
# build: chorus-precise64-master Continuous (bt323)
# project: Chorus
# URL: http://build.palaso.org/viewType.html?buildTypeId=bt323
# VCS: https://github.com/sillsdev/chorus.git [master]
# dependencies:
# [0] build: Helpprovider (bt225)
#     project: Helpprovider
#     URL: http://build.palaso.org/viewType.html?buildTypeId=bt225
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"Vulcan.Uczniowie.HelpProvider.dll"=>"lib/common"}
#     VCS: http://hg.palaso.org/helpprovider []
# [1] build: L10NSharp Mono continuous (bt271)
#     project: L10NSharp
#     URL: http://build.palaso.org/viewType.html?buildTypeId=bt271
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"L10NSharp.dll"=>"lib/ReleaseMono"}
#     VCS: https://bitbucket.org/sillsdev/l10nsharp []
# [2] build: L10NSharp Mono continuous (bt271)
#     project: L10NSharp
#     URL: http://build.palaso.org/viewType.html?buildTypeId=bt271
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"L10NSharp.dll"=>"lib/DebugMono"}
#     VCS: https://bitbucket.org/sillsdev/l10nsharp []
# [3] build: palaso-precise64-master Continuous (bt322)
#     project: libpalaso
#     URL: http://build.palaso.org/viewType.html?buildTypeId=bt322
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"Palaso.dll"=>"lib/ReleaseMono", "Palaso.TestUtilities.dll"=>"lib/ReleaseMono", "Palaso.Lift.dll"=>"lib/ReleaseMono", "PalasoUIWindowsForms.dll"=>"lib/ReleaseMono", "debug/Palaso.dll"=>"lib/DebugMono", "debug/Palaso.dll.mdb"=>"lib/DebugMono", "debug/Palaso.TestUtilities.dll"=>"lib/DebugMono", "debug/Palaso.TestUtilities.dll.mdb"=>"lib/DebugMono", "debug/Palaso.Lift.dll"=>"lib/DebugMono", "debug/Palaso.Lift.dll.mdb"=>"lib/DebugMono", "debug/PalasoUIWindowsForms.dll"=>"lib/DebugMono", "debug/PalasoUIWindowsForms.dll.mdb"=>"lib/DebugMono", "debug/PalasoUIWindowsForms.GeckoBrowserAdapter.dll"=>"lib/DebugMono", "debug/PalasoUIWindowsForms.GeckoBrowserAdapter.dll.mdb"=>"lib/DebugMono"}
#     VCS: https://github.com/sillsdev/libpalaso.git [master]
# [4] build: icucil-precise64-Continuous (bt281)
#     project: Libraries
#     URL: http://build.palaso.org/viewType.html?buildTypeId=bt281
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"*.dll"=>"lib/ReleaseMono", "*.config"=>"lib/ReleaseMono"}
#     VCS: https://github.com/sillsdev/icu-dotnet [master]
# [5] build: icucil-precise64-Continuous (bt281)
#     project: Libraries
#     URL: http://build.palaso.org/viewType.html?buildTypeId=bt281
#     clean: false
#     revision: latest.lastSuccessful
#     paths: {"*.dll"=>"lib/DebugMono", "*.config"=>"lib/DebugMono"}
#     VCS: https://github.com/sillsdev/icu-dotnet [master]

# make sure output directories exist
mkdir -p ../lib/DebugMono
mkdir -p ../lib/ReleaseMono
mkdir -p ../lib/common

# download artifact dependencies
copy_auto http://build.palaso.org/guestAuth/repository/download/bt225/latest.lastSuccessful/Vulcan.Uczniowie.HelpProvider.dll ../lib/common/Vulcan.Uczniowie.HelpProvider.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt271/latest.lastSuccessful/L10NSharp.dll ../lib/ReleaseMono/L10NSharp.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt271/latest.lastSuccessful/L10NSharp.dll ../lib/DebugMono/L10NSharp.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/Palaso.dll ../lib/ReleaseMono/Palaso.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/Palaso.TestUtilities.dll ../lib/ReleaseMono/Palaso.TestUtilities.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/Palaso.Lift.dll ../lib/ReleaseMono/Palaso.Lift.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/PalasoUIWindowsForms.dll ../lib/ReleaseMono/PalasoUIWindowsForms.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/Palaso.dll ../lib/DebugMono/Palaso.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/Palaso.dll.mdb ../lib/DebugMono/Palaso.dll.mdb
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/Palaso.TestUtilities.dll ../lib/DebugMono/Palaso.TestUtilities.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/Palaso.TestUtilities.dll.mdb ../lib/DebugMono/Palaso.TestUtilities.dll.mdb
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/Palaso.Lift.dll ../lib/DebugMono/Palaso.Lift.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/Palaso.Lift.dll.mdb ../lib/DebugMono/Palaso.Lift.dll.mdb
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/PalasoUIWindowsForms.dll ../lib/DebugMono/PalasoUIWindowsForms.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/PalasoUIWindowsForms.dll.mdb ../lib/DebugMono/PalasoUIWindowsForms.dll.mdb
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/PalasoUIWindowsForms.GeckoBrowserAdapter.dll ../lib/DebugMono/PalasoUIWindowsForms.GeckoBrowserAdapter.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt322/latest.lastSuccessful/debug/PalasoUIWindowsForms.GeckoBrowserAdapter.dll.mdb ../lib/DebugMono/PalasoUIWindowsForms.GeckoBrowserAdapter.dll.mdb
copy_auto http://build.palaso.org/guestAuth/repository/download/bt281/latest.lastSuccessful/icu.net.dll ../lib/ReleaseMono/icu.net.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt281/latest.lastSuccessful/icu.net.dll.config ../lib/ReleaseMono/icu.net.dll.config
copy_auto http://build.palaso.org/guestAuth/repository/download/bt281/latest.lastSuccessful/icu.net.dll ../lib/DebugMono/icu.net.dll
copy_auto http://build.palaso.org/guestAuth/repository/download/bt281/latest.lastSuccessful/icu.net.dll.config ../lib/DebugMono/icu.net.dll.config
# End of script
