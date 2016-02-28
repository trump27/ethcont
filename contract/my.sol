contract my {
    struct Cust {
        string  name;
        string  fullname;
        int     amount;
    }

    Cust[] public custs;
    function regist(
        string  name,
        string  fullname,
        int     amount
    ) {
        custs.push(Cust(
            name,
            fullname,
            amount
        ));
    }
    function get(uint idx) constant returns
        (string name, string fullname, int amount) {
        Cust c = custs[idx];
        name = c.name;
        fullname = c.fullname;
        amount = c.amount;
    }
    function getCount() constant returns (uint count) {
        return custs.length;
    }
}