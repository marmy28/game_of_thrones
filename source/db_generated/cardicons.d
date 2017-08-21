/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('CardIcons', 'CardIcon', 'CardIcons');
 */
module db_generated.cardicons;
import db_constraints;
import mysql.result;

class CardIcon
{
    private int _nCardIconID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nCardIconID() const pure nothrow @safe @nogc
    {
        return _nCardIconID;
    }
    /// ditto
    final @property void nCardIconID(int value)
    {
        setter(_nCardIconID, value);
    }
    private string _cIconName;
    @UniqueConstraintColumn!("uc_CardIcons") @NotNull
    final @property string cIconName() const pure nothrow @safe @nogc
    {
        return _cIconName;
    }
    final @property void cIconName(string value)
    {
        setter(_cIconName, value);
    }
    private string _cDescription;
    final @property string cDescription() const pure nothrow @safe @nogc
    {
        return _cDescription;
    }
    final @property void cDescription(string value)
    {
        setter(_cDescription, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nCardIconID_,
         string cIconName_,
         string cDescription_)
    {
        this._nCardIconID = nCardIconID_;
        this._cIconName = cIconName_;
        this._cDescription = cDescription_;
        initializeKeyedItem();
    }
    this(Row CardIcon_)
    {
        _nCardIconID = CardIcon_[0].get!(int);
        _cIconName = CardIcon_[1].get!(string);
        if (CardIcon_.isNull(2))
        {
            _cDescription = null;
        }
        else
        {
            _cDescription = CardIcon_[2].get!(string);
        }
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nCardIconID = ", nCardIconID,
                " cIconName = ", cIconName,
                " cDescription = ", cDescription,
                "");
    }
}
class CardIcons
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nCardIconID, cIconName, cDescription FROM CardIcons";
    }
    mixin KeyedCollection!(CardIcon);
}
