/**
 * Holds information about units.
 *
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('Units', 'Unit', 'Units');
 */
module db_generated.units;
import db_constraints;
import mysql.result;

class Unit
{
    private int _nUnitID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nUnitID() const pure nothrow @safe @nogc
    {
        return _nUnitID;
    }
    /// ditto
    final @property void nUnitID(int value)
    {
        setter(_nUnitID, value);
    }
    private string _cName;
    @UniqueConstraintColumn!("uc_Units") @NotNull
    final @property string cName() const pure nothrow @safe @nogc
    {
        return _cName;
    }
    final @property void cName(string value)
    {
        setter(_cName, value);
    }
    private int _nAttack;
    @NotNull
    final @property int nAttack() const pure nothrow @safe @nogc
    {
        return _nAttack;
    }
    final @property void nAttack(int value)
    {
        setter(_nAttack, value);
    }
    private int _nDefense;
    @NotNull
    final @property int nDefense() const pure nothrow @safe @nogc
    {
        return _nDefense;
    }
    final @property void nDefense(int value)
    {
        setter(_nDefense, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nUnitID_,
         string cName_,
         int nAttack_,
         int nDefense_)
    {
        this._nUnitID = nUnitID_;
        this._cName = cName_;
        this._nAttack = nAttack_;
        this._nDefense = nDefense_;
        initializeKeyedItem();
    }
    this(Row Unit_)
    {
        _nUnitID = Unit_[0].get!(int);
        _cName = Unit_[1].get!(string);
        _nAttack = Unit_[2].get!(int);
        _nDefense = Unit_[3].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nUnitID = ", nUnitID,
                " cName = ", cName,
                " nAttack = ", nAttack,
                " nDefense = ", nDefense,
                "");
    }
}
class Units
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nUnitID, cName, nAttack, nDefense FROM Units";
    }
    mixin KeyedCollection!(Unit);
}
