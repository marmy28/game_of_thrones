/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('WesterosDecks', 'WesterosDeck', 'WesterosDecks');
 */
module db_generated.westerosdecks;
import db_constraints;
import mysql.result;

import db_generated.westeroscards;
@ForeignKeyConstraint!(
    "fk_WesterosDecks_WesterosCards_nWesterosCardID",
    ["nWesterosCardID"],
    "WesterosCards",
    ["nWesterosCardID"],
    Rule.restrict,
    Rule.restrict)
class WesterosDeck
{
    private int _nWesterosDeckID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nWesterosDeckID() const pure nothrow @safe @nogc
    {
        return _nWesterosDeckID;
    }
    /// ditto
    final @property void nWesterosDeckID(int value)
    {
        setter(_nWesterosDeckID, value);
    }
    private int _nWesterosCardID;
    @NotNull
    final @property int nWesterosCardID() const pure nothrow @safe @nogc
    {
        return _nWesterosCardID;
    }
    final @property void nWesterosCardID(int value)
    {
        setter(_nWesterosCardID, value);
    }
    private int _nDeckNumber;
    @NotNull
    final @property int nDeckNumber() const pure nothrow @safe @nogc
    {
        return _nDeckNumber;
    }
    final @property void nDeckNumber(int value)
    {
        setter(_nDeckNumber, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nWesterosDeckID_,
         int nWesterosCardID_,
         int nDeckNumber_)
    {
        this._nWesterosDeckID = nWesterosDeckID_;
        this._nWesterosCardID = nWesterosCardID_;
        this._nDeckNumber = nDeckNumber_;
        initializeKeyedItem();
    }
    this(Row WesterosDeck_)
    {
        _nWesterosDeckID = WesterosDeck_[0].get!(int);
        _nWesterosCardID = WesterosDeck_[1].get!(int);
        _nDeckNumber = WesterosDeck_[2].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nWesterosDeckID = ", nWesterosDeckID,
                " nWesterosCardID = ", nWesterosCardID,
                " nDeckNumber = ", nDeckNumber,
                "");
    }
}
class WesterosDecks
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nWesterosDeckID, nWesterosCardID, nDeckNumber FROM WesterosDecks";
    }
    mixin KeyedCollection!(WesterosDeck);
}
