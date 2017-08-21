module settings;

import dini;

class Settings
{
private:
    static string _host;
    static string _user;
    static string _pwd;
    static string _database;
public:
    static this()
    {
        Ini ini;
        ini.parse("source/game.conf");
        _host = ini["db"].getKey("host");
        _user = ini["db"].getKey("user");
        _pwd = ini["db"].getKey("pwd");
        _database = ini["db"].getKey("database");
    }
    @property
    {
        static string host()
        {
            return _host;
        }
        static string user()
        {
            return _user;
        }
        static string pwd()
        {
            return _pwd;
        }
        static string database()
        {
            return _database;
        }
        static string connection()
        {
            string _connection = "";
            _connection = "host=" ~ _host ~ ";";
            _connection ~= "user=" ~ _user ~ ";";
            _connection ~= "pwd=" ~ _pwd ~ ";";
            _connection ~= "db=" ~ _database;
            return _connection;
        }
    }
}
