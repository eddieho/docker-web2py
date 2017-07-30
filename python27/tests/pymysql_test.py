import pymysql.cursors

# Connect to the database
connection = pymysql.connect(host='web2py_mysql',
                             user='root',
                             password='Welcome1',
                             db='mysql',
                             charset='utf8mb4',
                             cursorclass=pymysql.cursors.DictCursor)

with connection.cursor() as cursor:
  sql = "select user, host from mysql.user"
  cursor.execute(sql)
  result = cursor.fetchone()
  print(result)
  result = cursor.fetchone()
  print(result)


