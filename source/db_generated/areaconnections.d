/**
 * Date: October 25, 2015
 * Regenerate: CALL `game_of_thrones`.`Utils_generateClass`('AreaConnections', 'AreaConnection', 'AreaConnections');
 */
module db_generated.areaconnections;
import db_constraints;
import mysql.result;

import db_generated.areas;
@ForeignKeyConstraint!(
    "fk_AreaConnections_nMainAreaID_Areas_nAreaID",
    ["nMainAreaID"],
    "Areas",
    ["nAreaID"],
    Rule.restrict,
    Rule.restrict)
@ForeignKeyConstraint!(
    "fk_AreaConnections_nSurroundingAreaID_Areas_nAreaID",
    ["nSurroundingAreaID"],
    "Areas",
    ["nAreaID"],
    Rule.restrict,
    Rule.restrict)
class AreaConnection
{
    private int _nAreaConnectionID;
    /// auto_increment
    @UniqueConstraintColumn!("PRIMARY") @NotNull
    final @property int nAreaConnectionID() const pure nothrow @safe @nogc
    {
        return _nAreaConnectionID;
    }
    /// ditto
    final @property void nAreaConnectionID(int value)
    {
        setter(_nAreaConnectionID, value);
    }
    private int _nMainAreaID;
    @UniqueConstraintColumn!("uc_AreaConnections") @NotNull
    final @property int nMainAreaID() const pure nothrow @safe @nogc
    {
        return _nMainAreaID;
    }
    final @property void nMainAreaID(int value)
    {
        setter(_nMainAreaID, value);
    }
    private int _nSurroundingAreaID;
    @UniqueConstraintColumn!("uc_AreaConnections") @NotNull
    final @property int nSurroundingAreaID() const pure nothrow @safe @nogc
    {
        return _nSurroundingAreaID;
    }
    final @property void nSurroundingAreaID(int value)
    {
        setter(_nSurroundingAreaID, value);
    }
    mixin KeyedItem!(UniqueConstraintColumn!("PRIMARY"));
    this(
         int nAreaConnectionID_,
         int nMainAreaID_,
         int nSurroundingAreaID_)
    {
        this._nAreaConnectionID = nAreaConnectionID_;
        this._nMainAreaID = nMainAreaID_;
        this._nSurroundingAreaID = nSurroundingAreaID_;
        initializeKeyedItem();
    }
    this(Row AreaConnection_)
    {
        _nAreaConnectionID = AreaConnection_[0].get!(int);
        _nMainAreaID = AreaConnection_[1].get!(int);
        _nSurroundingAreaID = AreaConnection_[2].get!(int);
        initializeKeyedItem();
    }
    final void printInfo()
    {
        std.stdio.writeln(
                " nAreaConnectionID = ", nAreaConnectionID,
                " nMainAreaID = ", nMainAreaID,
                " nSurroundingAreaID = ", nSurroundingAreaID,
                "");
    }

    // private Area _MainArea;
    // final @property Area MainArea() const pure nothrow @safe @nogc
    // {
    //     return _MainArea;
    // }
    // final @property void MainArea(Area value)
    // {
    //     setter(_MainArea, value);
    //     setter(_nMainAreaID, _MainArea.nAreaID, "nMainAreaID");
    // }
    // private Area _SurroundingArea;
    // final @property Area SurroundingArea() const pure nothrow @safe @nogc
    // {
    //     return _SurroundingArea;
    // }
    // final @property void SurroundingArea(Area value)
    // {
    //     setter(_SurroundingArea, value);
    //     setter(_nSurroundingAreaID, _SurroundingArea.nAreaID, "nSurroundingAreaID");
    // }
}
class AreaConnections
{
    final string selectStatement() const nothrow @nogc @safe
    {
        return "SELECT nAreaConnectionID, nMainAreaID, nSurroundingAreaID FROM AreaConnections";
    }
    // final void associateRelationships(ref Areas areas_)
    // {
    //     this.areas = areas_;
    //     this.each!(
    //         (AreaConnection a) =>
    //         {
    //             Areas.key_type i;
    //             if (a.fk_AreaConnections_nMainAreaID_Areas_nAreaID_key(i))
    //             {
    //                 a.MainArea = this._areas.get(i);
    //             }
    //             if (a.fk_AreaConnections_nSurroundingAreaID_Areas_nAreaID_key(i))
    //             {
    //                 a.SurroundingArea = this._areas.get(i);
    //             }
    //         }());
    // }
    mixin KeyedCollection!(AreaConnection);
}
