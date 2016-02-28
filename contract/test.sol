contract test {
    struct Cust {
        uint  name;
        uint  fullname;
        int     amount;
    }
    Cust[] public custs;
    function regist(
        uint  name,
        uint  fullname,
        int     amount
    ) {
        // custs.push(Cust(
            // name,
            // fullname,
            // amount
        // ));
        custs[custs.length++] = Cust(
            name,
            fullname,
            amount
        );
    }
    function get(uint idx) constant returns
        (uint name, uint fullname, int amount) {
        Cust c = custs[idx];
        name = c.name;
        fullname = c.fullname;
        amount = c.amount;
    }
    function getCount() constant returns (uint count) {
        return custs.length;
    }
}