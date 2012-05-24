wiki-expert
===========

soon-to-be-generic semantic associative expert system


### Co zrobię

Niedługo dodam zarys tego jak mogą działać algorytmy tworzenia relacji między danymi. 

### Generalnie

System:
Wywołuje za pomocą AJAX'a zapytania do serwera w takiej formie:

##### Zapytanie o liste

    [[zaznaczone_pole1,zaznaczone_pole2,...,zaznaczone_poleN], kategoria_zapytania, query_string]
  
  gdzie:
      
      zaznaczone_poleX - to id któregoś z już zaznaczonych elementów w kolumnach (może być puste)
      kategoria_zapytania - to nazwa kolumny w której chcemy odświeżyć wyniki (app, risk, fix)
      query_string - to tekst z paska wyszukiwania danej kolumny (może być puste)

##### Zapytanie o jeden dokument
    
    [[zaznaczone_pola],query_string, id_wybranego_dokumentu]
  
  gdzie:
    
    zaznaczone_pola - to id różnych aktualnie zaznaczonych pól (może być puste)
    query_string - to tekst z paska wyszukiwania danej kolumny (może być puste)
    id_wybranego_elementu - to id dokumentu którego dane będziemy ściągać
    

### Tworzenie relacji między dokumentami

Relacje między dokumentami tworzone są parę razy dziennie przez uruchomienie specjalnego WORKERA,
który porównuje dokumenty i zapamiętuje podobieństwo dwóch dokumentów w cache.

### Relacje

Relacje między dwoma dokumentami tworzone są biorąc pod uwagę:
* wiedzę ekspercką - 'eksperci'/'wikipedyści' sami zaznaczają które tematy są ze sobą powiązane, relacja wygląda mniej więcej tak:

        [id_dokumentu1, id_dokumentu2, wartość_podobieństwa_ujemna_lub_dodatnia] 
    
* podobieństwo tekstowe dokumentów - WORKER sprawdza czy dwa dokumenty zawierają podobne słowa i wpisuje tą do cache.
* interakcje użytkowników - system zbiera informacje jakie zapytania obślużył system i jeżeli np. wszyscy użytkownicy wybierają naraz dokument Facebook i dokument Google, system kojarzy te fakty i automatycznie rekomenduje Google jeżeli zaznaczyło się Facebook.

System uwzględnia również pasek wyszukiwania podczas wyświetlania wyników.


### JOBS - prace WORKERA

* prepare
* * prepare:expert - tworzy cache dla danych ekspertów
* * prepare:ui - tworzy cache analizując dane z interfejsu użytkownika (zapytania)
* * prepare:semantic - tworzy cache porównując teksty dokumentów
* * prepare:join - łączy wcześniejsze dane w końcowy CACHE (sumuje inne CACHE)
    