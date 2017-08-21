/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('HouseAreaUnits', 'HouseAreaUnit', 'HouseAreaUnits');
 */
module db_generated.houseareaunits;
import db_constraints;
import mysql.result;

import db_generated.houseareas;
import db_generated.units;
@ForeignKeyConstraint!(
    "fk_HouseAreaUnits_HouseAreas_nHouseAreaID",
    ["nHouseAreaID"],
    "HouseAreas",
    ["nHouseAreaID"],
    Rule.restrict,
    Rule.restrict)
@ForeignKeyConstraint!(
    "fk_HouseAreaUnits_Units_nUnitID",
    ["nUnitID"],
    "Units",
    ["nUnitID"],
    Rule.restrict,
    Rule.restrict)
class HouseAreaUnit
{
    private int _nHouseAreaUnitID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nHouseAreaUnitID() const pure nothrow @safe @nogc
    {
        return _nHouseAreaUnitID;
    }
    /// ditto
    final @property void nHouseAreaUnitID(int value)
    {
        setter(_nHouseAreaUnitID, value);
    }
    private int _nHouseAreaID;
    @UniqueConstraintColumn!("uc_HouseAreaUnits") @NotNull
    final @property int nHouseAreaID() const pure nothrow @safe @nogc
    {
        return _nHouseAreaID;
    }
    final @property void nHouseAreaID(int value)
    {
        setter(_nHouseAreaID, value);
    }
    private int _nUnitID;
    @UniqueConstraintColumn!("uc_HouseAreaUnits") @NotNull
    final @property int nUnitID() const pure nothrow @safe @nogc
    {
        return _nUnitID;
    }
    final @property void nUnitID(int value)
    {
        setter(_nUnitID, value);
    }
    private int _nNumUnits;
    @NotNull
    final @property int nNumUnits() const pure nothrow @safe @nogc
    {
        return _nNumUnits;
    }
    final @property void nNumUnits(int value)
    {
        setter(_nNumUnits, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nHouseAreaUnitID_,
         int nHouseAreaID_,
         int nUnitID_,
         int nNumUnits_)
    {
        this._nHouseAreaUnitID = nHouseAreaUnitID_;
        this._nHouseAreaID = nHouseAreaID_;
        this._nUnitID = nUnitID_;
        this._nNumUnits = nNumUnits_;
        initializeKeyedItem();
    }
    this(Row HouseAreaUnit_)
    {
        _nHouseAreaUnitID = HouseAreaUnit_[0].get!(int);
        _nHouseAreaID = HouseAreaUnit_[1].get!(int);
        _nUnitID = HouseAreaUnit_[2].get!(int);
        _nNumUnits = HouseAreaUnit_[3].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nHouseAreaUnitID = ", nHouseAreaUnitID,
                " nHouseAreaID = ", nHouseAreaID,
                " nUnitID = ", nUnitID,
                " nNumUnits = ", nNumUnits,
                "");
    }
}
class HouseAreaUnits
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nHouseAreaUnitID, nHouseAreaID, nUnitID, nNumUnits FROM HouseAreaUnits";
    }
    mixin KeyedCollection!(HouseAreaUnit);
}
