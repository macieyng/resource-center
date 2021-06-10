import logging

from django.db import connection
from django.test.utils import CaptureQueriesContext

logger = logging.getLogger(__name__)


class PrintQueriesContext(CaptureQueriesContext):
    """
    print(str(queryset.query)) does NOT always print actual sql query because of django-safedelete, this class does.
    """
    def __init__(self):
        super().__init__(connection)
        
    def __exit__(self, exc_type, exc_value, traceback):
        queries = self.captured_queries
        message = [f'PrintQueriesContext - captured queries {len(queries)}']
        for index, query in enumerate(queries, start=1):
            message.append(f'{index}. time: {query["time"]}, sql:')
            message.append(query['sql'])
        logger.warning('\n'.join(message))
        super().__exit__(exc_type, exc_value, traceback)
 
