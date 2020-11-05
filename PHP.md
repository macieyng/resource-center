### Logging snippet

```php
function write_log($log_msg)
{
    $log_filename = "logs";
    if (!file_exists($log_filename))
    {
        mkdir($log_filename, 0777, true);
    }
    $log_file_data = $log_filename.'/debug.txt';
  file_put_contents($log_file_data, date("Y-m-d h:i:s") . "\t". $log_msg . "\n", FILE_APPEND);
   
}
```
