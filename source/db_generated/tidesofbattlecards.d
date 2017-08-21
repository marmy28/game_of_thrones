/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('TidesOfBattleCards', 'TidesOfBattleCard', 'TidesOfBattleCards');
 */
module db_generated.tidesofbattlecards;
import db_constraints;
import mysql.result;

import db_generated.cardabilitysets;
@ForeignKeyConstraint!(
    "fk_TidesOfBattleCards_CardAbilitiesSets_nCardAbilitySetID",
    ["nCardAbilitySetID"],
    "CardAbilitySets",
    ["nCardAbilitySetID"],
    Rule.setNull,
    Rule.setNull)
class TidesOfBattleCard
{
    private int _nTidesOfBattleCardID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nTidesOfBattleCardID() const pure nothrow @safe @nogc
    {
        return _nTidesOfBattleCardID;
    }
    /// ditto
    final @property void nTidesOfBattleCardID(int value)
    {
        setter(_nTidesOfBattleCardID, value);
    }
    private int _nCombatStrength;
    @NotNull
    final @property int nCombatStrength() const pure nothrow @safe @nogc
    {
        return _nCombatStrength;
    }
    final @property void nCombatStrength(int value)
    {
        setter(_nCombatStrength, value);
    }
    private Nullable!int _nCardAbilitySetID;
    final @property Nullable!int nCardAbilitySetID() const pure nothrow @safe @nogc
    {
        return _nCardAbilitySetID;
    }
    final @property void nCardAbilitySetID(N)(N value)
        if (isNullable!(int, N))
    {
        setter(_nCardAbilitySetID, value.to!(Nullable!int));
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nTidesOfBattleCardID_,
         int nCombatStrength_,
         Nullable!(int) nCardAbilitySetID_)
    {
        this._nTidesOfBattleCardID = nTidesOfBattleCardID_;
        this._nCombatStrength = nCombatStrength_;
        this._nCardAbilitySetID = nCardAbilitySetID_;
        initializeKeyedItem();
    }
    this(Row TidesOfBattleCard_)
    {
        _nTidesOfBattleCardID = TidesOfBattleCard_[0].get!(int);
        _nCombatStrength = TidesOfBattleCard_[1].get!(int);
        if (TidesOfBattleCard_.isNull(2))
        {
            _nCardAbilitySetID.nullify();
        }
        else
        {
            _nCardAbilitySetID = TidesOfBattleCard_[2].get!(int);
        }
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nTidesOfBattleCardID = ", nTidesOfBattleCardID,
                " nCombatStrength = ", nCombatStrength,
                " nCardAbilitySetID = ", nCardAbilitySetID.isNull ? to!string(null) : to!string(nCardAbilitySetID.get),
                "");
    }
}
class TidesOfBattleCards
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nTidesOfBattleCardID, nCombatStrength, nCardAbilitySetID FROM TidesOfBattleCards";
    }
    mixin KeyedCollection!(TidesOfBattleCard);
}
