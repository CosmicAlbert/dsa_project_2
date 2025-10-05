import ballerina/http;
import ballerina/log;
import ballerina/time;


type Passenger record {|
    string passengerId?;
    string firstName;
    string lastName;
    string email;
    string password;
    string phoneNumber;
    string createdAt?;
    string status?;
|};

type LoginRequest record {|
    string email;
    string password;
|};

type LoginResponse record {|
    boolean success;
    string message;
    string? passengerId;
|};

map<Passenger> passengers = {};


service /passenger on new http:Listener(9001) {

    resource function post register(@http:Payload Passenger passenger) returns json|error {
        foreach var p in passengers {
            if (p.email == passenger.email) {
                return {
                    "success": false,
                    "message": "Email already registered"
                };
            }
        }

        string passengerId = "PASS" + time:utcNow()[0].toString();
        passenger.passengerId = passengerId;
        passenger.status = "ACTIVE";
        passenger.createdAt = time:utcToString(time:utcNow());

        passengers[passengerId] = passenger;

        log:printInfo("Passenger registered: " + passengerId);

        return {
            "success": true,
            "message": "Passenger registered successfully",
            "passengerId": passengerId
        };
    }

    resource function post login(@http:Payload LoginRequest loginReq) returns LoginResponse|error {
        foreach var [id, p] in passengers.entries() {
            if (p.email == loginReq.email && p.password == loginReq.password) {
                return {
                    success: true,
                    message: "Login successful",
                    passengerId: id
                };
            }
        }
        
        return {
            success: false,
            message: "Invalid email or password",
            passengerId: ()
        };
    }

    resource function get profile/[string passengerId]() returns Passenger|http:NotFound|error {
        if (passengers.hasKey(passengerId)) {
            return passengers.get(passengerId);
        }
        return http:NOT_FOUND;
    }

    resource function get tickets/[string passengerId]() returns json|error {
        return {
            "passengerId": passengerId,
            "tickets": []
        };
    }

    resource function get health() returns json {
        return {
            "service": "passenger-service",
            "status": "UP",
            "timestamp": time:utcToString(time:utcNow())
        };
    }
}