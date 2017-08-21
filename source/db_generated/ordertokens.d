/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('OrderTokens', 'OrderToken', 'OrderTokens');
 */
module db_generated.ordertokens;
import db_constraints;
import mysql.result;

import db_generated.orders;
@ForeignKeyConstraint!(
    "fk_OrderTokens_Orders_nOrderID",
    ["nOrderID"],
    "Orders",
    ["nOrderID"],
    Rule.restrict,
    Rule.restrict)
class OrderToken
{
    private int _nOrderTokenID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nOrderTokenID() const pure nothrow @safe @nogc
    {
        return _nOrderTokenID;
    }
    /// ditto
    final @property void nOrderTokenID(int value)
    {
        setter(_nOrderTokenID, value);
    }
    private int _nOrderID;
    @NotNull
    final @property int nOrderID() const pure nothrow @safe @nogc
    {
        return _nOrderID;
    }
    final @property void nOrderID(int value)
    {
        setter(_nOrderID, value);
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
    private bool _lSpecial;
    @NotNull
    final @property bool lSpecial() const pure nothrow @safe @nogc
    {
        return _lSpecial;
    }
    final @property void lSpecial(bool value)
    {
        setter(_lSpecial, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nOrderTokenID_,
         int nOrderID_,
         int nCombatStrength_,
         bool lSpecial_)
    {
        this._nOrderTokenID = nOrderTokenID_;
        this._nOrderID = nOrderID_;
        this._nCombatStrength = nCombatStrength_;
        this._lSpecial = lSpecial_;
        initializeKeyedItem();
    }
    this(Row OrderToken_)
    {
        _nOrderTokenID = OrderToken_[0].get!(int);
        _nOrderID = OrderToken_[1].get!(int);
        _nCombatStrength = OrderToken_[2].get!(int);
        _lSpecial = to!(bool)(OrderToken_[3].get!(byte));
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nOrderTokenID = ", nOrderTokenID,
                " nOrderID = ", nOrderID,
                " nCombatStrength = ", nCombatStrength,
                " lSpecial = ", lSpecial,
                "");
    }
}
class OrderTokens
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nOrderTokenID, nOrderID, nCombatStrength, lSpecial FROM OrderTokens";
    }
    mixin KeyedCollection!(OrderToken);
}
