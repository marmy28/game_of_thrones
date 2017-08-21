/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('WesterosCards', 'WesterosCard', 'WesterosCards');
 */
module db_generated.westeroscards;
import db_constraints;
import mysql.result;

import db_generated.cardabilitysets;
@ForeignKeyConstraint!(
    "fk_WesterosCards_CardAbilitiesSets_nCardAbilitySetID",
    ["nCardAbilitySetID"],
    "CardAbilitySets",
    ["nCardAbilitySetID"],
    Rule.restrict,
    Rule.restrict)
class WesterosCard
{
    private int _nWesterosCardID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nWesterosCardID() const pure nothrow @safe @nogc
    {
        return _nWesterosCardID;
    }
    /// ditto
    final @property void nWesterosCardID(int value)
    {
        setter(_nWesterosCardID, value);
    }
    private string _cName;
    @UniqueConstraintColumn!("uc_WesterosCards") @NotNull
    final @property string cName() const pure nothrow @safe @nogc
    {
        return _cName;
    }
    final @property void cName(string value)
    {
        setter(_cName, value);
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
         int nWesterosCardID_,
         string cName_,
         int nCardAbilitySetID_)
    {
        this._nWesterosCardID = nWesterosCardID_;
        this._cName = cName_;
        this._nCardAbilitySetID = nCardAbilitySetID_;
        initializeKeyedItem();
    }
    this(Row WesterosCard_)
    {
        _nWesterosCardID = WesterosCard_[0].get!(int);
        _cName = WesterosCard_[1].get!(string);
        _nCardAbilitySetID = WesterosCard_[2].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nWesterosCardID = ", nWesterosCardID,
                " cName = ", cName,
                " nCardAbilitySetID = ", nCardAbilitySetID,
                "");
    }
}
class WesterosCards
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nWesterosCardID, cName, nCardAbilitySetID FROM WesterosCards";
    }
    mixin KeyedCollection!(WesterosCard);
}
