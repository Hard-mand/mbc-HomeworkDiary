import Time "mo:base/Time";

// Define el tipo de registro "Homework"
module {
    public type Time = Time.Time;
    public type Homework = {
        title : Text;
        description : Text;
        dueDate : Time;
        completed : Bool;
    };
};
