# worklog

__Skrypty do rejestrowania pracy__ 


Działa pod UBUNTU 16.04, 18.04, 20.04 oraz częściowo pod ZORIN, a także pod 
Windows w oknie obsługiwanym przez bash z MINGW64 (bez kontroli "idle time").

**SPOSÓB UŻYCIA**

0) Zainstalować gita :-)
1) Stworzyć własną kopię tego repozytorium na **GitHub**, **GitLab** lub 
   podobnej usłudze.
2) Sklonować własną kopię do katalogu domowego jako _.worklog_
3) Z wnętrza katalogu _.worklog_ uruchomić skrypt `./install.sh`
4) Ewentualnie dopisać własne aliasy i funkcje, jeśli gotowy zestaw nie pokrywa 
   się z uzywanymi programami
5) Zsynchronizować z repozytorium
6) Postąpić analogicznie na innych używanych komputerach


**Zawartość katalogu**

* `install.sh` - instalacja skryptów. Odpalać z katalogu, w którym sklonowano 
                 repozytorium. W razie potrzeby edytować ścieżkę ustawioną 
                 domyślnie na _~/.worklog_ 
* `aliases.sh` - źródło skryptu wstawiane na koniec _.profile_ i _.bashrc_, 
                 zawierające funkcje i aliasy tego pakietu i trochę innych, 
                 ewentualnie użytecznych
* `idle.sh` - skrypt rejestrujący minuty bezczynności użytkownika
* `dbusmonitor.sh` - skrypt odpalany z _.profile_, który nasłuchuje "szyny 
	zdarzeń" _gnome_ i rejestruje w logu uśpienia i obudzenia konsoli graficznej.
* `wlog.sh|wlog|log` - zapis wszystkich parametrów do logu pracy wraz z datą,
	czasem, nazwą użytkownika i nazwą serwera (redundancja zamierzona)
* `wgit.sh|wgit|git` - wraper do _git_. Tylko niektóre operacje, 
	np. `add/commit/push`, są rejestrowane w logu. Użycie parametru -m 
	wymaga zmiany spacji na znaki '_'. 
* `lworks.sh|works/lw [-NN]` - wyświetlanie zawartości końca logu pracy. Można 
	podać parametr, np. `-10` żeby okreslić liczbę linii.
* `wfinish.sh|wfinish NAZWA` - zakończenie okresu czasu, np. miesiąca. Aktualny 
	plik zostaje przemianowany na plik rozpoczynający
	się od `NAZWA` i zmiany zostają zarejestrowane w 
	lokalnym repozytorium _git_.
* `{user}-{server}.log`  - aktualny log pracy
* `oldlogs/` - katalog na zakończone logi gracy
* `*.out` - różne pliki robocze, np. `sleep.out`,`idle.out` itp. Nie podlegają
	  synchronizacji z repozytorium.
* `.PROJECT.WLOG.INFO` - wzorcowy plik z informacją o przynalezności katalogu do
 			projektu i "work package" w danym projekcie. W każdym 
 			katalogu można umieścić plik o takiej nazwie. W przypadku 
 			jego braku dane pobierane są z pliku znalezionego powyżej.
* `README.md`  - ten plik opisu.

**Ważniejsze funkcje zdefiniowane przez plik aliases.sh**

* `whelp` - lista wszystkich poleceń zdefiniowanych przez `aliases.sh`
* `wlog|log`, `wgit|git`, `works|lw`, `wfinish` - skróty do głównych skryptów.
* `wedit` - funkcja umożliwiająca poprawienie logu pracy w przypadku błędów.
* `wsearch` - funkcja umożliwiająca przeszukowanie logów za pomoca wyrażeń regularnych.
* `wdiff` - funkcja sprawdzający co w logu jest jeszcze nie zarejestrowane 
	    w _git_. 
* `wcommit` - funkcja rejestrująca zmiany logu w _git_ . Wywoływana automatycznie
	    na początku i końcu pracy terminala
* `wsave` - funkcja synchronizująca ze zdalnym serwerem _git_ . Trzeba ją wywoływać
	    jawnie, bo wymaga podania hasła
* `wsync` - funkcja dwukierunkowej synchronizacji z repozytorium.
* `wps`  - sprawdzenie czy są obecne procesy działające w tle służące do 
	   monitorowania konsoli graficznej
* `wcpu` - sprawdzenie i zapis do logu aktualnego obciążenia procesorów.
* `wsudo` - dodatkowo rejestrowana w logu wersja _sudo_.

**Ważniejsze nakładki umożliwiające rejestracje wywołań programów**

* `mail` - funkcja wraper na mailer _Thunderbird_ . Można spróbować zamienić na inny.
* `ssh` - funkcja wraper na _ssh_ zapisujący do logu początek i koniec sesji
* `qt` - funkcja wraper do _QtCreatora_ zapisujący do logu początek i koniec sesji
* `cl` - funkcja wraper do _CLion_
* `pr` - funkcja wraper do _Processing_

**Zmienne systemowe**

Skrypt _aliases.sh_ ustawia i eksportuje 3 zmienne shella, o domyślnych wartościach jak poniżej:

* `WORKLOG_VERSION="(2.0)"` - wersja zestawu skryptów
* `WORKLOG="${HOME}/.worklog/"` - katalog ze skryptami
* `WLOGFILE=${WORKLOG}"$(whoami)-$(hostname).log"` - nazwa pliku logu

Można je odpowiednio zmodyfikować, ale trzeba to uwzględnić także w skrypcie `wfinish.sh`

Ustawiane są też i eksportowane zmienne zawierające kody kolorów na konsoli tekstowej. 
Są one używane w skryptach pakietu, ale można też używać we własnych.

* `ECHO="echo -e"`
* `COLOR0="\e[37m"` - ŻADEN?
* `COLOR1="\e[36m"` - CYAN
* `COLOR2="\e[35m"` - MAGENTA
* `COLOR3="\e[34m"` - BLUE
* `COLOR4="\e[33m"` - YELLOW
* `COLOR5="\e[32m"` - GREEN
* `COLOR6="\e[31m"` - RED
* `COLOR7="\e[30m"` - DARK

* `COLERR="\e[31m"` - ERROR = RED
* `COLFIL="\e[34m"` - FILL  = BLUE
* `NORMCO="\e[0m"`  - NORMALIZACJA KOLORU

## For private repository use "ssh" protocol!!!

Aktualnie dla tej aplikacji jedyny możliwy sposób użycia z _gitHub_'a jest 
przez protokół "ssh" !

```
git clone <ssh-url> ~/.worklog
```

**COFFEE**

Jeżeli uznasz, że te skrypty pomagają ci w pracy to postaw mi kawę :-) 

* https://www.buymeacoffee.com/wborkowsk
* https://www.paypal.com/paypalme/wborkowsk



