/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('HouseCards', 'HouseCard', 'HouseCards');
 */
module db_generated.housecards;
import db_constraints;
import mysql.result;

import db_generated.cardabilitysets;
import db_generated.houses;
@ForeignKeyConstraint!(
    "fk_HouseCards_CardAbilitiesSets_nCardAbilitySetID",
    ["nCardAbilitySetID"],
    "CardAbilitySets",
    ["nCardAbilitySetID"],
    Rule.restrict,
    Rule.restrict)
@ForeignKeyConstraint!(
    "fk_HouseCards_Houses_nHouseID",
    ["nHouseID"],
    "Houses",
    ["nHouseID"],
    Rule.restrict,
    Rule.restrict)
class HouseCard
{
    private int _nHouseCardID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nHouseCardID() const pure nothrow @safe @nogc
    {
        return _nHouseCardID;
    }
    /// ditto
    final @property void nHouseCardID(int value)
    {
        setter(_nHouseCardID, value);
    }
    private string _cPersonName;
    @UniqueConstraintColumn!("uc_HouseCards") @NotNull
    final @property string cPersonName() const pure nothrow @safe @nogc
    {
        return _cPersonName;
    }
    final @property void cPersonName(string value)
    {
        setter(_cPersonName, value);
    }
    private int _nHouseID;
    @NotNull
    final @property int nHouseID() const pure nothrow @safe @nogc
    {
        return _nHouseID;
    }
    final @property void nHouseID(int value)
    {
        setter(_nHouseID, value);
    }
    private int _nCombatStrength;
    /// The number on the upper left side of the card
    @NotNull
    final @property int nCombatStrength() const pure nothrow @safe @nogc
    {
        return _nCombatStrength;
    }
    /// ditto
    final @property void nCombatStrength(int value)
    {
        setter(_nCombatStrength, value);
    }
    private int _nCardAbilitySetID;
    @NotNull
    final @property int nCardAbilitySetID() const pure nothrow @safe @nogc
    {
        return _nCardAbilitySetID;
    }
    final @property void nCardAbilitySetID(int value)
    {
        setter(_nCardAbilitySetID, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nHouseCardID_,
         string cPersonName_,
         int nHouseID_,
         int nCombatStrength_,
         int nCardAbilitySetID_)
    {
        this._nHouseCardID = nHouseCardID_;
        this._cPersonName = cPersonName_;
        this._nHouseID = nHouseID_;
        this._nCombatStrength = nCombatStrength_;
        this._nCardAbilitySetID = nCardAbilitySetID_;
        initializeKeyedItem();
    }
    this(Row HouseCard_)
    {
        _nHouseCardID = HouseCard_[0].get!(int);
        _cPersonName = HouseCard_[1].get!(string);
        _nHouseID = HouseCard_[2].get!(int);
        _nCombatStrength = HouseCard_[3].get!(int);
        _nCardAbilitySetID = HouseCard_[4].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nHouseCardID = ", nHouseCardID,
                " cPersonName = ", cPersonName,
                " nHouseID = ", nHouseID,
                " nCombatStrength = ", nCombatStrength,
                " nCardAbilitySetID = ", nCardAbilitySetID,
                "");
    }
}
class HouseCards
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nHouseCardID, cPersonName, nHouseID, nCombatStrength, nCardAbilitySetID FROM HouseCards";
    }
    mixin KeyedCollection!(HouseCard);
}
