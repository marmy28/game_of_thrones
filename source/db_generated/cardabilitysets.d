/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('CardAbilitySets', 'CardAbilitySet', 'CardAbilitySets');
 */
module db_generated.cardabilitysets;
import db_constraints;
import mysql.result;

class CardAbilitySet
{
    private int _nCardAbilitySetID;
    @UniqueConstraintColumn!("PRIMARY") @NotNull
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
         int nCardAbilitySetID_)
    {
        this._nCardAbilitySetID = nCardAbilitySetID_;
        initializeKeyedItem();
    }
    this(Row CardAbilitySet_)
    {
        _nCardAbilitySetID = CardAbilitySet_[0].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nCardAbilitySetID = ", nCardAbilitySetID,
                "");
    }
}
class CardAbilitySets
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nCardAbilitySetID FROM CardAbilitySets";
    }
    mixin KeyedCollection!(CardAbilitySet);
}
