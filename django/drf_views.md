# Z jakich widoków korzystać w DRF?

## Widok `APIView`
Z dokumentacji DRF:
>REST framework provides an `APIView` class, which subclasses Django's `View` class.
>
>APIView classes are different from regular View classes in the following ways:
>
>    - Requests passed to the handler methods will be REST framework's `Request` instances, not Django's `HttpRequest` instances.
>    - Handler methods may return REST framework's `Response`, instead of Django's `HttpResponse`. The view will manage content negotiation and setting the correct renderer on the response.
>    - Any `APIException` exceptions will be caught and mediated into appropriate responses.
>    - Incoming requests will be authenticated and appropriate permission and/or throttle checks will be run before dispatching the request to the handler method.
>
>Using the `APIView` class is pretty much the same as using a regular `View` class, as usual, the incoming request is dispatched to an appropriate handler method such as `.get()` or `.post()`. Additionally, a number of attributes may be set on the class that control various aspects of the API policy.

Oznacza to mniej więcej tyle, że podstawową klasą widoków w `DRF` jest klasa `APIView`, która wymaga implementacji podstawowych metod takich jak `.get()` czy `.post()`. Ta klasa nie dostarcza warstwy abtrakcji pozwalającej na szybkie dostoswanie widoku do typowych rozwiązań związanych z REST API, takich jak np. paginacja czy filtry.

## Widoki generyczne `generics.*`

Z dokumentacji DRF:
>One of the key benefits of class-based views is the way they allow you to compose bits of reusable behavior. REST framework takes advantage of this by providing a number of pre-built views that provide for commonly used patterns.
>
>The generic views provided by REST framework allow you to quickly build API views that map closely to your database models.
>
>If the generic views don't suit the needs of your API, you can drop down to using the regular `APIView` class, or reuse the mixins and base classes used by the generic views to compose your own set of reusable generic views.

Oznacza to, że widoki generyczne są bardziej wyspecjalizowane w porównaniu z `APIView`. 

### Podstawowa klasa widoków generycznych - `GenericAPIView`

Z dokumentacji DRF:
>This class extends REST framework's APIView class, adding commonly required behavior for standard list and detail views.
>
>Each of the concrete generic views provided is built by combining GenericAPIView, with one or more mixin classes.

#### Ustawienia
- `queryset` - zapytanie, na którym wykonywany jest widok ([Czym jest queryset?](https://docs.djangoproject.com/en/3.1/ref/models/querysets/)), np. `queryset = User.objects.all()`
- `serializer_class ` - klasa serializera ([Czym jest serializer?](https://www.django-rest-framework.org/api-guide/serializers/)), np. `serializer = UserSerializer`
- `lookup_field` - pole modelu na którym wykonywane jest zapytanie, domyślnie `pk`
- `lookup_url_kwarg` - argument nazwany (keyword argument, kwarg), którego wartość zawarta w URL, który ma być użyty w zapytaniu. Jeśli nie jest ustawiony ma tą samą wartość co `lookup_field`
- `pagination_class` - używane z widokiem listującym, które przyjmuje jako wartośc klasę paginacji. Domyślnie jest to `DEFAULT_PAGINATION_CLASS` czyli `rest_framework.pagination.PageNumberPagination`. Ustawienie `pagination_class = None` wyłączy paginację dla danej klasy
- `filter_backends` - lista klas filtrów, która powinna być użyta dla zapytania. Domyślnie jest to `DEFAULT_FILTER_BACKENDS`

#### Metody
- [`get_queryset()`](https://www.django-rest-framework.org/api-guide/generic-views/#get_querysetself) - metoda, która powinna być używana do pobierania obiektów w widoku listującym. Domyślnie zwraca zapytanie (`queryset`). Metodę tą można nadpisać, by zaimplementować bardziej dynamiczne zachowanie, np. zwracanie obiektu(ów), który właścicielem jest użytkownik. Korzystanie z metody jest preferowane ponad pobieranie zapytania bezpośrednio:

    DOBRZE:
    ```python
    q = self.get_queryset()
    ```
    ŹLE:
    ```python
    q = self.queryset
    ```
- [`get_object()`](https://www.django-rest-framework.org/api-guide/generic-views/#get_objectself) - metoda, która zwraca obiekt, używana w widoku szczegółowym. Domyślnie używa `lookup_field` do znalezienia obiektu w bazie. Może być nadpisana, by realizować bardziej złożone zapytania. 
- [`filter_queryset()`](https://www.django-rest-framework.org/api-guide/generic-views/#filter_querysetself-queryset) - metoda filtrująca queryset
- [`get_serializer_class()`](https://www.django-rest-framework.org/api-guide/generic-views/#get_serializer_classself) - domyślnie zwraca `serializer_class`.  Metodę tą można nadpisać, by zaimplementować bardziej złożone zachowanie, np. zwrócenie innego typu serializera w zależności od typu konta użytkownika.
##### Inne metody:
- `get_serializer_context(self)` - Returns a dictionary containing any extra context that should be supplied to the serializer. Defaults to including `request`, `view` and `format` keys.
- `get_serializer(self, instance=None, data=None, many=False, partial=False)` - Returns a serializer instance.
- `get_paginated_response(self, data)` - Returns a paginated style Response object.
- `paginate_queryset(self, queryset)` - Paginate a queryset if required, either returning a page object, or None if pagination is not configured for this view.

    

### Mixins

> A mixin is a special kind of multiple inheritance. There are two main situations where mixins are used:
>
>    1. You want to provide a lot of optional features for a class.
>    2. You want to use one particular feature in a lot of different classes.

[Więcej o mixinach](https://stackoverflow.com/questions/533631/what-is-a-mixin-and-why-are-they-useful) | 
[Jeszcze więcej o mixinach](https://www.thedigitalcatonline.com/blog/2020/03/27/mixin-classes-in-python/)


Widoki generyczne są opart na 5 podstawowych Mixin'ach. Poniżej ich lista wraz z implementacją.

1. `ListModelMixin` dostarcza jedną metodę, która może być używana do zwrócenia listy obiektów wg zadanego parametru `queryset`, który powinna posiadać klasa, która dziedziczy tego mixina.
    ```python
    class ListModelMixin:
        """
        List a queryset.
        """
        def list(self, request, *args, **kwargs):
            queryset = self.filter_queryset(self.get_queryset())

            page = self.paginate_queryset(queryset)
            if page is not None:
                serializer = self.get_serializer(page, many=True)
                return self.get_paginated_response(serializer.data)

            serializer = self.get_serializer(queryset, many=True)
            return Response(serializer.data)
    ```
        


2. `CreateModelMixin` dostarcza metody `create()`, `perform_create()` oraz `get_success_headers()`. W przypadku sukcesu metoda `create` zwraca zserializowany obiekt, kod 201 oraz nagłóweki zapytania. `perform_create` jest wraperem zapisywania serializera, który ma za zadania ułatwić nadpisanie zachowania zapisu obiektu na podstawie serializera. Literka `C - create` w akronimie `CRUD`.
    ```python
    class CreateModelMixin:
        """
        Create a model instance.
        """
        def create(self, request, *args, **kwargs):
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)

        def perform_create(self, serializer):
            serializer.save()

        def get_success_headers(self, data):
            try:
                return {'Location': str(data[api_settings.URL_FIELD_NAME])}
            except (TypeError, KeyError):
                return {}
    ```
3. `RetrieveModelMixin` posiada jedną metodę, która zwraca obiekt. Litera `R - read` w akronimie `CRUD`.
    ```python
    class RetrieveModelMixin:
        """
        Retrieve a model instance.
        """
        def retrieve(self, request, *args, **kwargs):
            instance = self.get_object()
            serializer = self.get_serializer(instance)
            return Response(serializer.data)
    ```
4. `UpdateModelMixin` widok pozwalający na aktualizowanie konkretnego obiektu. Metoda `update` pozwala na aktualizację całościową (`PUT`) lub częściową (`PATCH`), metoda `perform_update` jest wrapperem tworzenia obiektu na podstawie serializera i pozwala na nadpisanie zachowania. Metoda `partial_update` pozwala na korzystanie z zapytania HTTP `PATCH`. Litera `U - update` w akronimie `CRUD`.
    ```python
    class UpdateModelMixin:
        """
        Update a model instance.
        """
        def update(self, request, *args, **kwargs):
            partial = kwargs.pop('partial', False)
            instance = self.get_object()
            serializer = self.get_serializer(instance, data=request.data, partial=partial)
            serializer.is_valid(raise_exception=True)
            self.perform_update(serializer)

            if getattr(instance, '_prefetched_objects_cache', None):
                # If 'prefetch_related' has been applied to a queryset, we need to
                # forcibly invalidate the prefetch cache on the instance.
                instance._prefetched_objects_cache = {}

            return Response(serializer.data)

        def perform_update(self, serializer):
            serializer.save()

        def partial_update(self, request, *args, **kwargs):
            kwargs['partial'] = True
            return self.update(request, *args, **kwargs)
    ```
5. `DestroyModelMixin` widok dostarczający metodę `destroy` oraz `perform_destroy`. Litera `D - delete` w akronimie `CRUD`.
    ```python
    class DestroyModelMixin:
        """
        Destroy a model instance.
        """
        def destroy(self, request, *args, **kwargs):
            instance = self.get_object()
            self.perform_destroy(instance)
            return Response(status=status.HTTP_204_NO_CONTENT)

        def perform_destroy(self, instance):
            instance.delete()

    ```

### Konkretne widoki
> The following classes are the concrete generic views. If you're using generic views this is normally the level you'll be working at unless you need heavily customized behavior.
>
>The view classes can be imported from `rest_framework.generics`.




|Nazwa widoku|Zadanie|Metody|Rozszerza|
|---|---|---|---|
|`CreateAPIView`|Zapis instancji modelu|`post`|`GenericAPIVIew` `CreateModelMixin`|
|`ListAPIView`|Odczyt reprezentacji kolekcji instancji danego modelu|`get`|`GenericAPIVIew` `ListModelMixin`|
|`RetrieveAPIView`|Odczyt reprezentacji instancji danego modelu|`get`|`GenericAPIVIew` `RetrieveModelMixin`|
|`DestroyAPIView`|Usuwanie instancji danego modelu|`delete`|`GenericAPIVIew` `DestroyModelMixin`|
|`UpdateAPIView`|Aktualizacja instancji danego modelu|`put` `patch`|`GenericAPIVIew` `UpdateModelMixin`|
|`ListCreateAPIView`|Odczyt i zapis reprezentacji kolekcji instancji danego modelu|`get` `post`|`GenericAPIVIew` `ListModelMixin` `CreateModelMixin`|
|`RetriveUpdateAPIView`|Odczyt i aktualizacja instancji modelu|`get` `put` `patch`|`GenericAPIVIew` `RetrieveModelMixin` `UpdateModelMixin`|
|`RetrieveDestroyAPIView`|Odczyt i usuwanie instancji modelu|`get` `delete`|`GenericAPIVIew` `RetrieveModelMixin` `DestroyModelMixin`|
|`RetrieveUpdateDestoryAPIView`|Odczyt, zapis i usuwanie instancji modelu|`get` `put` `patch` `delete`|`GenericAPIVIew` `RetrieveModelMixin` `UpdateModelMixin` `DestroyModelMixin`|


### Kiedy używać
|Nazwa widoku|Zastosowanie|
|---|---|
|`CreateAPIView`|Kiedy endpoint ma za zadanie tylko tworzyć nową instancję|
|`ListAPIView`|Kiedy endpoint ma za zadanie tylko pobrać listę reprezentacji utworzonych instancji|
|`RetrieveAPIView`|Kiedy endpoint ma za zadanie tylko zwrócić reprezentację konkretnej instancji|
|`DestroyAPIView`|Kiedy endpoint ma za zadnie tylko usunąć konkretną instancję|
|`UpdateAPIView`|Kiedy endpoint ma za zadanie tylko aktualizować konkretną instancję|
|`ListCreateAPIView`|Kiedy endpoint ma za zadanie tylko zwrócić listę reprezentancji utworzonych instancji lub utworzyć nową instancję|
|`RetriveUpdateAPIView`|Kiedy endpoint ma za zadanie tylko zwrócić reprezentację konkretnej instancji lub zaktualizować konkretną instancję|
|`RetrieveDestroyAPIView`|Kiedy endpoint ma za zadanie tylko zwrócić reprezentację konkretnej instancji lub usunąć konkretną instancję|
|`RetrieveUpdateDestoryAPIView`|Kiedy endpoint ma za zadanie tylko zwrócić reprezentację konkretnej instancji lub zaktualizować konkretną instancję lub usunąć konkretną instancję|

#### Tabela metod HTTP od klasy widoku

|Nazwa widoku|`get` (1\|0)| `get` (>=0)|`post`|`put`|`patch`|`delete`|
|---|---|---|---|---|---|---|
|`CreateAPIView`|||+||||
|`ListAPIView`||+|||||
|`RetrieveAPIView`|+||||||
|`DestroyAPIView`||||||+|
|`UpdateAPIView`||||+|+||
|`ListCreateAPIView`||+|+||||
|`RetrieveUpdateAPIView`|+|||+|+||
|`RetrieveDestroyAPIView`|+|||||+|
|`RetrieveUpdateDestoryAPIView`|+|||+|+|+|

Z powyższej tabli można wywnioskować, że `ListCreateAPIView` oraz `RetrieveUpdateDestoryAPIView` są komplementarne i pozwalają na pełne spektrum operacji przy zachowaniu możliwie najmniejszej ilości widoków i endpointów. 

Te dwa widoki powinny być brane pod uwagę jako widoki startowe. Jeśli pewne zachowanie powinno być wydzielone do innego endpointu (ergo innego widoku), wtedy można zmniejszyć odpowiedzialność pierwszego widoku i przenieść ją do nowego widoku. 

Na przykład, mając początkowo widok dziedziczący po `RetrieveUpdateDestoryAPIView`, chcielibyśmy, aby API nie udostępniało możliwości usuwania instancji obiektu, więc zwmieniamy klasę po której dziedziczy nasz widoku na `RetrieveUpdateAPIView`.



### Do przeczytania
[Dostosowywanie widoków generycznych](https://www.django-rest-framework.org/api-guide/generic-views/#customizing-the-generic-views)
