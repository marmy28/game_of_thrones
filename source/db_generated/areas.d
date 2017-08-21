/**
 * Holds all the information about the areas.
 *
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('Areas', 'Area', 'Areas');
 */
module db_generated.areas;
import db_constraints;
import mysql.result;

class Area
{
    private int _nAreaID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nAreaID() const pure nothrow @safe @nogc
    {
        return _nAreaID;
    }
    /// ditto
    final @property void nAreaID(int value)
    {
        setter(_nAreaID, value);
    }
    private string _cName;
    @UniqueConstraintColumn!("uc_Areas") @NotNull
    final @property string cName() const pure nothrow @safe @nogc
    {
        return _cName;
    }
    final @property void cName(string value)
    {
        setter(_cName, value);
    }
    private int _nSupply;
    /// How many barrels are on the area
    @NotNull
    final @property int nSupply() const pure nothrow @safe @nogc
    {
        return _nSupply;
    }
    /// ditto
    final @property void nSupply(int value)
    {
        setter(_nSupply, value);
    }
    private int _nPower;
    /// How many crowns are on the area
    @NotNull
    final @property int nPower() const pure nothrow @safe @nogc
    {
        return _nPower;
    }
    /// ditto
    final @property void nPower(int value)
    {
        setter(_nPower, value);
    }
    private int _nMusteringPoints;
    /// whether there is a castle, stronghold, or nothing on this area
    @NotNull
    final @property int nMusteringPoints() const pure nothrow @safe @nogc
    {
        return _nMusteringPoints;
    }
    /// ditto
    final @property void nMusteringPoints(int value)
    {
        setter(_nMusteringPoints, value);
    }
    private bool _lIsSea;
    @NotNull
    final @property bool lIsSea() const pure nothrow @safe @nogc
    {
        return _lIsSea;
    }
    final @property void lIsSea(bool value)
    {
        setter(_lIsSea, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nAreaID_,
         string cName_,
         int nSupply_,
         int nPower_,
         int nMusteringPoints_,
         bool lIsSea_)
    {
        this._nAreaID = nAreaID_;
        this._cName = cName_;
        this._nSupply = nSupply_;
        this._nPower = nPower_;
        this._nMusteringPoints = nMusteringPoints_;
        this._lIsSea = lIsSea_;
        initializeKeyedItem();
    }
    this(Row Area_)
    {
        _nAreaID = Area_[0].get!(int);
        _cName = Area_[1].get!(string);
        _nSupply = Area_[2].get!(int);
        _nPower = Area_[3].get!(int);
        _nMusteringPoints = Area_[4].get!(int);
        _lIsSea = to!(bool)(Area_[5].get!(byte));
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nAreaID = ", nAreaID,
                " cName = ", cName,
                " nSupply = ", nSupply,
                " nPower = ", nPower,
                " nMusteringPoints = ", nMusteringPoints,
                " lIsSea = ", lIsSea,
                "");
    }
}
class Areas
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nAreaID, cName, nSupply, nPower, nMusteringPoints, lIsSea FROM Areas";
    }
    mixin KeyedCollection!(Area);
}
