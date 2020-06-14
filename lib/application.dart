
String dbName = 'conquali.db';
int dbVersion = 1;

List<String> dbCreate = [
  """
    CREATE TABLE funcionario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        status INTEGER,
        created TEXT
    )
  """,
  """
    CREATE TABLE equipe ( 
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        status INTEGER,
        created TEXT
    )
  """,
  """
    CREATE TABLE equipe_funcionario (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      equipe INTEGER,
      funcionario INTEGER,
      created TEXT,
      FOREIGN KEY(equipe) REFERENCES equipe(id),      
      FOREIGN KEY(funcionario) REFERENCES funcionario(id)
    )
  """
];