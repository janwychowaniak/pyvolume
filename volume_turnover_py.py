
# [https://github.com/BitMEX/api-connectors/tree/master/official-http/python-swaggerpy]
# [https://www.bitmex.com/api/explorer/#/]



import bitmex
import json
from time import gmtime, strftime
import sys

from datetime import datetime
from datetime import date
from datetime import timedelta


#  dla Stats.Stats_get
#~ def find_root_symbol_data(_stats_list, _root_symbol):
    #~ for item in _stats_list:
        #~ if item['rootSymbol'] == _root_symbol:
            #~ return item
    #~ return None


def get_now():
    """
    Zwraca np. '2018-06-15__21:27'
    """
    return strftime("%Y-%m-%d__%H:%M", gmtime())


def get_dataX():
    """
    Zwraca bieżącą date, np. '2018-06-15', gdy nie dalej od startu dnia, niż zadana liczba minut;
    '.', gdy dalej
    """
    teraz = datetime.now()
    data = datetime.combine(date.today(), datetime.min.time())
    roznica = teraz - data
    roznica_max = timedelta(seconds=0, minutes=25, hours=0)
    return "." if roznica > roznica_max else data.strftime("%m-%d-")


def get_dataline(_datapiece, _timestamp):
    return str(_datapiece) + " " + _timestamp


def append_datapiece(_plik, _datapiece):
    with open(_plik, "a") as myfile:
        myfile.write(_datapiece + "\n")


if __name__ == '__main__':


    if len(sys.argv) != 5:
        sys.stderr.write('Usage:')                                                                                      ; sys.stderr.flush()
        sys.stderr.write('  %s   plik_turnover24h   plik_volume24h   plik_openInterest   plik_openValue' % sys.argv[0]) ; sys.stderr.flush()
        sys.stderr.write('\n')                                                                                          ; sys.stderr.flush()
        sys.exit(1)

    plik_turnover24h  = sys.argv[1]
    plik_volume24h    = sys.argv[2]
    plik_openInterest = sys.argv[3]
    plik_openValue    = sys.argv[4]

	
    # client = bitmex.bitmex()         # klient testnetowy (defaultowo test=True)
    client = bitmex.bitmex(test=False) # klient livenetowy

    #  dla Stats.Stats_get
    #~ stats_list=client.Stats.Stats_get().result()[0]
    #~ stats_item_XBT = find_root_symbol_data(stats_list, 'XBT')
    #~ print (stats_item_XBT)


    # ============

    instrument_data_XBTUSD = client.Instrument.Instrument_get(filter=json.dumps({'symbol': 'XBTUSD'})).result()[0][0]

    turnover24h  = instrument_data_XBTUSD['turnover24h']
    volume24h    = instrument_data_XBTUSD['volume24h']
    openInterest = instrument_data_XBTUSD['openInterest']
    openValue    = instrument_data_XBTUSD['openValue']
    
    #~ turnover24h_datapiece  = get_dataline(turnover24h , get_now())
    #~ volume24h_datapiece    = get_dataline(volume24h   , get_now())
    #~ openInterest_datapiece = get_dataline(openInterest, get_now())
    #~ openValue_datapiece    = get_dataline(openValue   , get_now())

    turnover24h_datapiece  = get_dataline(turnover24h , get_dataX())
    volume24h_datapiece    = get_dataline(volume24h   , get_dataX())
    openInterest_datapiece = get_dataline(openInterest, get_dataX())
    openValue_datapiece    = get_dataline(openValue   , get_dataX())

    
    print ("turnover24h_datapiece  : " + turnover24h_datapiece)
    print ("volume24h_datapiece    : " + volume24h_datapiece)
    print ("openInterest_datapiece : " + openInterest_datapiece)
    print ("openValue_datapiece    : " + openValue_datapiece)
    
    print ("plik_turnover24h  : " + plik_turnover24h)
    print ("plik_volume24h    : " + plik_volume24h)
    print ("plik_openInterest : " + plik_openInterest)
    print ("plik_openValue    : " + plik_openValue)
    

    append_datapiece(plik_turnover24h , turnover24h_datapiece)
    append_datapiece(plik_volume24h   , volume24h_datapiece)
    append_datapiece(plik_openInterest, openInterest_datapiece)
    append_datapiece(plik_openValue   , openValue_datapiece)
    
