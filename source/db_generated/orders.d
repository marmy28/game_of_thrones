/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('Orders', 'Order', 'Orders');
 */
module db_generated.orders;
import db_constraints;
import mysql.result;

class Order
{
    private int _nOrderID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nOrderID() const pure nothrow @safe @nogc
    {
        return _nOrderID;
    }
    /// ditto
    final @property void nOrderID(int value)
    {
        setter(_nOrderID, value);
    }
    private string _cOrderName;
    @UniqueConstraintColumn!("uc_Orders") @NotNull
    final @property string cOrderName() const pure nothrow @safe @nogc
    {
        return _cOrderName;
    }
    final @property void cOrderName(string value)
    {
        setter(_cOrderName, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nOrderID_,
         string cOrderName_)
    {
        this._nOrderID = nOrderID_;
        this._cOrderName = cOrderName_;
        initializeKeyedItem();
    }
    this(Row Order_)
    {
        _nOrderID = Order_[0].get!(int);
        _cOrderName = Order_[1].get!(string);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nOrderID = ", nOrderID,
                " cOrderName = ", cOrderName,
                "");
    }
}
class Orders
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nOrderID, cOrderName FROM Orders";
    }
    mixin KeyedCollection!(Order);
}
