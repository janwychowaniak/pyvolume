
# [https://stackoverflow.com/questions/24101524/finding-median-of-list-in-python#answer-24101534]


import sys


def median_custom(lst):
	sortedLst = sorted(lst)
	lstLen = len(lst)
	index = (lstLen - 1) // 2
	if (lstLen % 2):
		return round(sortedLst[index])
	else:
		return round((sortedLst[index] + sortedLst[index + 1])/2.0)


def dziel_wiersz(_wiersz):
    """
    31400178781950 2018-06-16  ->  ['31400178781950', '2018-06-16']
    """
    return _wiersz.split()

def scalaj_wiersz(_wiersz_rozjebany):
    """
    ['31400178781950', '2018-06-16']  ->  31400178781950 2018-06-16
    """
    return "" + _wiersz_rozjebany[0] + " " + _wiersz_rozjebany[1]

#####################################################################################################
                                                                                                   ##
from pprint import pprint                                                                          ##
                                                                                                   ##
def test__dziel_wiersz ():                                                                         ##
    assert dziel_wiersz("31400178781950 2018-06-16") == ['31400178781950', '2018-06-16']           ##
    assert dziel_wiersz("31400178781960 2018-06-17") == ['31400178781960', '2018-06-17']           ##
                                                                                                   ##
def test__scalaj_wiersz():                                                                         ##
    assert scalaj_wiersz(['31400178781950', '2018-06-16']) == ("31400178781950 2018-06-16")        ##
    assert scalaj_wiersz(['31400178781960', '2018-06-17']) == ("31400178781960 2018-06-17")        ##
                                                                                                   ##
#####################################################################################################

if __name__ == '__main__':


    if len(sys.argv) != 3:
        sys.stderr.write('Usage:')                                              ; sys.stderr.flush()
        sys.stderr.write('  %s   plik_danych   plik_out_mediany' % sys.argv[0]) ; sys.stderr.flush()
        sys.stderr.write('\n')                                                  ; sys.stderr.flush()
        sys.exit(1)

    plik_danych      = sys.argv[1]
    plik_out_mediany = sys.argv[2]

    dane_tablica = []
    
    with open(plik_danych) as dane_surowe:
        for line in dane_surowe:
            dane_tablica.append(dziel_wiersz(line))

    #~ pprint (dane_tablica)               ##############

    daneX = []
    
    for wiersz in dane_tablica:
        daneX.append(int(wiersz[0]))
    
    #~ pprint (daneX)               ##############

    mediana = median_custom(daneX)

    #~ pprint (mediana)               ##############

    mediana_tablica = []
    
    for wiersz in dane_tablica:
        mediana_tablica.append([str(mediana), wiersz[1]])

    #~ pprint (mediana_tablica)               ##############

    mediana_tablica_scalone = []
    
    for wiersz in mediana_tablica:
        mediana_tablica_scalone.append(scalaj_wiersz(wiersz))

    #~ pprint (mediana_tablica_scalone)               ##############

    with open(plik_out_mediany, "w") as wylot:
        #~ wylot.writelines(mediana_tablica_scalone)
        wylot.write('\n'.join(mediana_tablica_scalone))
            
    print (plik_danych + " ---> " + plik_out_mediany)
    
