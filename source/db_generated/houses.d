/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('Houses', 'House', 'Houses');
 */
module db_generated.houses;
import db_constraints;
import mysql.result;

class House
{
    private int _nHouseID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nHouseID() const pure nothrow @safe @nogc
    {
        return _nHouseID;
    }
    /// ditto
    final @property void nHouseID(int value)
    {
        setter(_nHouseID, value);
    }
    private string _cName;
    @UniqueConstraintColumn!("uc_Houses") @NotNull
    final @property string cName() const pure nothrow @safe @nogc
    {
        return _cName;
    }
    final @property void cName(string value)
    {
        setter(_cName, value);
    }
    private int _nIronThrone;
    @NotNull
    final @property int nIronThrone() const pure nothrow @safe @nogc
    {
        return _nIronThrone;
    }
    final @property void nIronThrone(int value)
    {
        setter(_nIronThrone, value);
    }
    private int _nFiefdom;
    @NotNull
    final @property int nFiefdom() const pure nothrow @safe @nogc
    {
        return _nFiefdom;
    }
    final @property void nFiefdom(int value)
    {
        setter(_nFiefdom, value);
    }
    private int _nKingsCourt;
    @NotNull
    final @property int nKingsCourt() const pure nothrow @safe @nogc
    {
        return _nKingsCourt;
    }
    final @property void nKingsCourt(int value)
    {
        setter(_nKingsCourt, value);
    }
    private int _nSupply;
    @NotNull
    final @property int nSupply() const pure nothrow @safe @nogc
    {
        return _nSupply;
    }
    final @property void nSupply(int value)
    {
        setter(_nSupply, value);
    }
    private int _nVictory;
    @NotNull
    final @property int nVictory() const pure nothrow @safe @nogc
    {
        return _nVictory;
    }
    final @property void nVictory(int value)
    {
        setter(_nVictory, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nHouseID_,
         string cName_,
         int nIronThrone_,
         int nFiefdom_,
         int nKingsCourt_,
         int nSupply_,
         int nVictory_)
    {
        this._nHouseID = nHouseID_;
        this._cName = cName_;
        this._nIronThrone = nIronThrone_;
        this._nFiefdom = nFiefdom_;
        this._nKingsCourt = nKingsCourt_;
        this._nSupply = nSupply_;
        this._nVictory = nVictory_;
        initializeKeyedItem();
    }
    this(Row House_)
    {
        _nHouseID = House_[0].get!(int);
        _cName = House_[1].get!(string);
        _nIronThrone = House_[2].get!(int);
        _nFiefdom = House_[3].get!(int);
        _nKingsCourt = House_[4].get!(int);
        _nSupply = House_[5].get!(int);
        _nVictory = House_[6].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nHouseID = ", nHouseID,
                " cName = ", cName,
                " nIronThrone = ", nIronThrone,
                " nFiefdom = ", nFiefdom,
                " nKingsCourt = ", nKingsCourt,
                " nSupply = ", nSupply,
                " nVictory = ", nVictory,
                "");
    }
}
class Houses
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nHouseID, cName, nIronThrone, nFiefdom, nKingsCourt, nSupply, nVictory FROM Houses";
    }
    mixin KeyedCollection!(House);
}
