/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('HouseAreas', 'HouseArea', 'HouseAreas');
 */
module db_generated.houseareas;
import db_constraints;
import mysql.result;

import db_generated.areas;
import db_generated.houses;
@ForeignKeyConstraint!(
    "fk_HouseAreas_Areas_nAreaID",
    ["nAreaID"],
    "Areas",
    ["nAreaID"],
    Rule.restrict,
    Rule.restrict)
@ForeignKeyConstraint!(
    "fk_HouseAreas_Houses_nHouseID",
    ["nHouseID"],
    "Houses",
    ["nHouseID"],
    Rule.restrict,
    Rule.restrict)
class HouseArea
{
    private int _nHouseAreaID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nHouseAreaID() const pure nothrow @safe @nogc
    {
        return _nHouseAreaID;
    }
    /// ditto
    final @property void nHouseAreaID(int value)
    {
        setter(_nHouseAreaID, value);
    }
    private int _nHouseID;
    @UniqueConstraintColumn!("uc_HouseAreas") @NotNull
    final @property int nHouseID() const pure nothrow @safe @nogc
    {
        return _nHouseID;
    }
    final @property void nHouseID(int value)
    {
        setter(_nHouseID, value);
    }
    private int _nAreaID;
    @UniqueConstraintColumn!("uc_HouseAreas") @NotNull
    final @property int nAreaID() const pure nothrow @safe @nogc
    {
        return _nAreaID;
    }
    final @property void nAreaID(int value)
    {
        setter(_nAreaID, value);
    }
    private int _nNumPlayers;
    @UniqueConstraintColumn!("uc_HouseAreas") @NotNull
    final @property int nNumPlayers() const pure nothrow @safe @nogc
    {
        return _nNumPlayers;
    }
    final @property void nNumPlayers(int value)
    {
        setter(_nNumPlayers, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nHouseAreaID_,
         int nHouseID_,
         int nAreaID_,
         int nNumPlayers_)
    {
        this._nHouseAreaID = nHouseAreaID_;
        this._nHouseID = nHouseID_;
        this._nAreaID = nAreaID_;
        this._nNumPlayers = nNumPlayers_;
        initializeKeyedItem();
    }
    this(Row HouseArea_)
    {
        _nHouseAreaID = HouseArea_[0].get!(int);
        _nHouseID = HouseArea_[1].get!(int);
        _nAreaID = HouseArea_[2].get!(int);
        _nNumPlayers = HouseArea_[3].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nHouseAreaID = ", nHouseAreaID,
                " nHouseID = ", nHouseID,
                " nAreaID = ", nAreaID,
                " nNumPlayers = ", nNumPlayers,
                "");
    }
}
class HouseAreas
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nHouseAreaID, nHouseID, nAreaID, nNumPlayers FROM HouseAreas";
    }
    mixin KeyedCollection!(HouseArea);
}
