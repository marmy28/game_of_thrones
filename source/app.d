import std.stdio;
import dini;
import settings;
import db_generated;
import std.algorithm;
import mysql.connection;
import mysql.protocol.commands;
import mysql.result;
import db_constraints.keyed.keyedcollection : Enforce;

void main()
{

	auto units = GetFromDB!(HouseCards)();
	foreach(unit; units)
	{
		unit.printInfo();
	}

	//units.byValue.filter!(a => a.nAttack > 1).each!(a => a.printInfo());
}


template GetFromDB(Table)
{
	Table GetFromDB(Command command)
	{
		auto result = new Table();
		result.enforceConstraints = Enforce.none;
		command.sql = result.selectStatement();
		command.prepare();
		ResultSet rs = command.execSQLResult();
		foreach(row; rs)
		{
			result.add(new Table.collectionof(row));
		}
		result.rehash;
		result.enforceConstraints = Enforce.unique | Enforce.foreignKey;
		return result;
	}
	Table GetFromDB(string connection)
	{
		auto con = new Connection(connection);
		scope(exit) con.close();
		auto command = Command(con);
		return GetFromDB!(Table)(command);
	}
	Table GetFromDB()
	{
		return GetFromDB!(Table)(Settings.connection);
	}
}
