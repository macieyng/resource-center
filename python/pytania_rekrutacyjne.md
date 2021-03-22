Pytania rekrutacyjne
https://4programmers.net/Forum/Python/327204-pytania_rekrutacyjne_python_django

1. Napisz funkcję generującą kolejne elementy ciągu Fibonacciego
    1. Rekurencyjnie 
    ```python
    def fibo(n):
        if n == 0:
            return 0
        if n == 1 or n == 2:
            return 1
        return fibo(n-1) + fibo(n-2)

    def get_n_fibo(n):
        for i in range(n):
            yield fibo(i)

    print(list(get_n_fibo(10)))
    ```
    ```python
    def fibo(n):  
        if n <= 1:  
            return n  
        else:  
            return fibo(n-1) + fibo(n-2) 
    ```
    1. Iteracyjnie
    ```python
    def fibo(n):
        fibo_lst = []
        for i in range(n):
            if i == 0:
                fibo_lst.append(0)
            elif i == 1 or i == 2:
                fibo_lst.append(1)
            else:
                n_1 = fibo_lst[-1]
                n_2 = fibo_lst[-2]
                fibo_lst.append(n_1 + n_2)
        return fibo_lst
    ```
    
3. zamień wartości dwóch zmiennych
    ```python
    a = 2
    b = 5
    print(a, b) # 2, 5
    a, b = b, a
    print(a, b) # 5, 2
    ```
5. co to jest i do czego służy type?
    
    `type` jest funkcją wbudowaną w bibliotekę standardową Pythona, która zwraca klasę obiektu podanego jako argument tej fukncji
    ```python
    type(object) == object.__class__
    ```
7. czy parametry do funkcji są w pythonie przekazywanie przez wartość, czy referencję?
    
    W Pythonie wszystkie argumenty są przekazywane przez przypisanie. W momencie przekazania argumentu jest tworzona jego kopia, na której są wykonywane operacje i na której wartość nie wpływa na argument oryginalny.
9. jakie są podstawowe typy w pythonie?
    
    `int float bool str object complex list dict tuple`
11. czy python jest językiem kompilowanym czy skryptowym? słabo czy silnie typowanym? co to jest duck-typing?
    
    Python jest językiem interpretowanym. Część kodu może zostać skompilowana do postaci binarnej dla zwiększenia wydajności. Python jest językiem słabo typowanym. Typy zmiennych nie są wymagane, ale są możliwe, np. za pomocą typów prostych, własnych obiektów lub z pomocą modułu `typing`
13. do czego służą i czym się różnią metody:
    1. `__init__` vs `__new__`
    
        `__new__` jest konstruktorem, a `__init__` jest inicjalizerem.

        `__new__` jest wykonywany jako pierwsza metoda w momencie utworzenia obiektu. Używa się go specjalnej kontroli tworzenia klasy i zwraca nową instancję klasy. 
        `__init__` jest wykonywany w momencie inicjalizacji obiektu. Używa się go specjalnej kontroli tworzenia obiektu.
        
        https://dev.to/pila/constructors-in-python-init-vs-new-2f9j
    3. `__str__` vs `__repr__`
    
        https://stackoverflow.com/questions/1436703/what-is-the-difference-between-str-and-repr
    5. `__add__` vs `__radd__`

        
17. czym się różni metoda od funkcji?
18. co to jest self? czy self jest słowem kluczowym?
19. co to jest słowo kluczowe (keyword)?
20. co oznacza instrukcja pass? kiedy można jej użyć?
21. co to są built-iny?
22. jakie znasz sposoby na konkatenację stringów? których warto, a których nie warto używać i dlaczego?
23. czym się różni list i dict?
24. czym się różni set i list?
25. co to jest list/dict comprehension?
26. jak działa wielokrotne dziedziczenie w pythonie?
27. co to jest mixin i kiedy warto go użyć?
28. co to jest MTV?
29. ile poleci zapytań do bazy w trakcie wykonywania funkcji:
    ```python
    def dashboard(request):
    items = Item.objects.all()
    return render(request, 'index.html')
    ```
1. jak poradzić sobie z tłumaczeniem aplikacji napisanej w Django?
1. pola jakiego typu użyjesz w modelu do przechowywania stanu konta użytkownika?
1. co to jest manager w Django?
1. co to jest context manager?
1. czy kiedykolwiek miałeś sytuację, w której ORM cię ograniczał?
1. co jest nie tak z poniższym kodem? Jak byś go poprawił?
    ```python
    items = Item.objects.all()
    for item in items:
    print(item.buyer.last_name)
    ```
1. czym się różni select_related od prefetch_related?
1. jakich narzędzi/paczek/aplikacji używasz pisząc aplikację w Django?
1. co to jest middleware?
1. co to jest model abstrakcyjny?
1. co to jest model proxy?
1. co to są migracje?
1. co wyróżnia Django na tle innych (pythonowych) webowych frameworków/bibliotek?
1. jakie bazy danych są oficjalnie wspierane przez Django?
1. jaka jest aktualna wersja pythona i Django?
1. czym się różni python 2 od pythona 3?
1. co to jest moduł?
1. co to jest wersja LTS Django?
1. w jaki sposób (i po co) rozszerzyć bazową klasę User z Django?
1. co to są szablony?
1. opisz co się dzieje z zapytaniem HTTP w kontekście aplikacji napisanej w Django
1. do czego służy django.db.transaction.atomic i jak można tego użyć?
1. którą bazę danych wybierzesz pisząc aplikację w Django i dlaczego?
1. co to jest, i jak Django pozwala zapobiec: XSS, clickjacking, SQL injection, CSRF?
1. jak Django zarządza hasłami użytkowników?
1. co to jest AnonymousUser?
1. jak sprawdzisz, czy aktualnie zalogowany użytkownik jest superuserem?
1. jak sprawdzisz czy dany użytkownik ma uprawnienie do wykonania danej akcji?
1. jak w Django można nadać uprawnienia użytkownikowi?
1. jak wyślesz użytkownikowi duży plik, który został wygenerowany na jego żądanie?
1. jak można deployować aplikację napisaną w Django?
1. co to jest Docker i jak może on pomóc w pisaniu aplikacji (niekoniecznie w Django)?
1. w jaki sposób działa i na co pozwala panel administratora w Django?
1. 1 lub 2 proste zadania na rozgrzewke (cos naprawde prostego, pogrupowac elementy, cos pofiltrowac zadania na 5 minut max)
1. pytania killer "Jak dziala slownik? " albo "Jak dziala tablica ?" :P
1. lista z 10 milionami elementow:
    1. `[{"klucz1": "wartosc1"}, {"klucz2": "wartosc2"}, ....]`
    2. `[("klucz1", "wartosc1"), ("klucz2", "wartosc2", ....)`
1. Co lepiej wybrac i dlaczego ? Co to jest ___slots___ ?
1. dekotarory (z parametrem) + dekorowanie klas (po co do czego ?)
1. programowanie funkcyjne ( co to ? + clousure )
1. multiprocessing vs multithreading vs asyncio (co to programowanie asynchroniczne, GIL itp)
1. SOLID
1. zaprojektowanie Twittera/Facebooka/Youtube/....<wstaw dowolna="dowolna" web="web" aplikacje="aplikacje">
1. (requirementy, architektura (model, schemat, deployment), dane , bottlenecki, technologie)
1. SQL vs NoSQL - (generalnie i w obrebie NoSQL document vs key-value vs column, sharding itp itd)
1. CAP theorem
1. wedlug jakich kryteriow mozna podzielic API aplikacji monolitycznej na mikroserwisy - wady zalety doswiadczenia
1. HTTP ( HTTP perssisten, cookieys itp itd) , HTTPS (SSL)
1. Load Balancing, HA, Cacheowanie, DNS itp itd itp itd
1. techniki uwierzytelniania w aplikacjach webowych
1. Celery
1. z baz danych Indexy co to po co jest ?
1. `conection pool` co to po co ?
