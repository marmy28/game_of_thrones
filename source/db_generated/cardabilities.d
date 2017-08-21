/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('CardAbilities', 'CardAbility', 'CardAbilities');
 */
module db_generated.cardabilities;
import db_constraints;
import mysql.result;

import db_generated.cardabilitysets;
import db_generated.cardicons;
@ForeignKeyConstraint!(
    "fk_CardAbilities_CardAbilitiesSets_nCardAbilitySetID",
    ["nCardAbilitySetID"],
    "CardAbilitySets",
    ["nCardAbilitySetID"],
    Rule.restrict,
    Rule.restrict)
@ForeignKeyConstraint!(
    "fk_CardAbilities_CardIcons_nCardIconID",
    ["nCardIconID"],
    "CardIcons",
    ["nCardIconID"],
    Rule.restrict,
    Rule.restrict)
class CardAbility
{
    private int _nCardAbilityID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nCardAbilityID() const pure nothrow @safe @nogc
    {
        return _nCardAbilityID;
    }
    /// ditto
    final @property void nCardAbilityID(int value)
    {
        setter(_nCardAbilityID, value);
    }
    private int _nCardAbilitySetID;
    @UniqueConstraintColumn!("uc_CardAbilities") @NotNull
    final @property int nCardAbilitySetID() const pure nothrow @safe @nogc
    {
        return _nCardAbilitySetID;
    }
    final @property void nCardAbilitySetID(int value)
    {
        setter(_nCardAbilitySetID, value);
    }
    private int _nCardIconID;
    @UniqueConstraintColumn!("uc_CardAbilities") @NotNull
    final @property int nCardIconID() const pure nothrow @safe @nogc
    {
        return _nCardIconID;
    }
    final @property void nCardIconID(int value)
    {
        setter(_nCardIconID, value);
    }
    private int _nTimes;
    @NotNull
    final @property int nTimes() const pure nothrow @safe @nogc
    {
        return _nTimes;
    }
    final @property void nTimes(int value)
    {
        setter(_nTimes, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nCardAbilityID_,
         int nCardAbilitySetID_,
         int nCardIconID_,
         int nTimes_)
    {
        this._nCardAbilityID = nCardAbilityID_;
        this._nCardAbilitySetID = nCardAbilitySetID_;
        this._nCardIconID = nCardIconID_;
        this._nTimes = nTimes_;
        initializeKeyedItem();
    }
    this(Row CardAbility_)
    {
        _nCardAbilityID = CardAbility_[0].get!(int);
        _nCardAbilitySetID = CardAbility_[1].get!(int);
        _nCardIconID = CardAbility_[3].get!(int);
        _nTimes = CardAbility_[2].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nCardAbilityID = ", nCardAbilityID,
                " nCardAbilitySetID = ", nCardAbilitySetID,
                " nCardIconID = ", nCardIconID,
                " nTimes = ", nTimes,
                "");
    }
}
class CardAbilities
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nCardAbilityID, nCardAbilitySetID, nCardIconID, nTimes FROM CardAbilities";
    }
    mixin KeyedCollection!(CardAbility);
}
