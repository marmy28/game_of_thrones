/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('WildlingCards', 'WildlingCard', 'WildlingCards');
 */
module db_generated.wildlingcards;
import db_constraints;
import mysql.result;

class WildlingCard
{
    private int _nWildlingCardID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nWildlingCardID() const pure nothrow @safe @nogc
    {
        return _nWildlingCardID;
    }
    /// ditto
    final @property void nWildlingCardID(int value)
    {
        setter(_nWildlingCardID, value);
    }
    private string _cName;
    @UniqueConstraintColumn!("uc_WildlingCards") @NotNull
    final @property string cName() const pure nothrow @safe @nogc
    {
        return _cName;
    }
    final @property void cName(string value)
    {
        setter(_cName, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nWildlingCardID_,
         string cName_)
    {
        this._nWildlingCardID = nWildlingCardID_;
        this._cName = cName_;
        initializeKeyedItem();
    }
    this(Row WildlingCard_)
    {
        _nWildlingCardID = WildlingCard_[0].get!(int);
        _cName = WildlingCard_[1].get!(string);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nWildlingCardID = ", nWildlingCardID,
                " cName = ", cName,
                "");
    }
}
class WildlingCards
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nWildlingCardID, cName FROM WildlingCards";
    }
    mixin KeyedCollection!(WildlingCard);
}
