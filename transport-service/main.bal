import ballerina/http;
import ballerina/log;
import ballerina/time;

type Route record {|
    string routeId?;
    string routeName;
    string 'start;
    string end;
    string[] stops;
    string transportType;
    string status?;
    string createdAt?;
|};

type Trip record {|
    string tripId?;
    string routeId;
    string departureTime;
    string arrivalTime;
    string date;
    int capacity;
    int availableSeats?;
    string status?;
    string createdAt?;
|};

map<Route> routes = {};
map<Trip> trips = {};

service /transport on new http:Listener(9002) {

    resource function post routes(@http:Payload Route route) returns json|error {
        string routeId = "RT" + time:utcNow()[0].toString();
        route.routeId = routeId;
        route.status = "ACTIVE";
        route.createdAt = time:utcToString(time:utcNow());

        routes[routeId] = route;

        log:printInfo("Route created: " + routeId);

        return {
            "success": true,
            "message": "Route created successfully",
            "routeId": routeId
        };
    }

    resource function get routes() returns Route[]|error {
        Route[] routeList = [];
        foreach var route in routes {
            routeList.push(route);
        }
        return routeList;
    }

    resource function get routes/[string routeId]() returns Route|http:NotFound|error {
        if (routes.hasKey(routeId)) {
            return routes.get(routeId);
        }
        return http:NOT_FOUND;
    }

    resource function post trips(@http:Payload Trip trip) returns json|error {
        string tripId = "TRIP" + time:utcNow()[0].toString();
        trip.tripId = tripId;
        trip.availableSeats = trip.capacity;
        trip.status = "SCHEDULED";
        trip.createdAt = time:utcToString(time:utcNow());

        trips[tripId] = trip;

        log:printInfo("Trip created: " + tripId);

        return {
            "success": true,
            "message": "Trip created successfully",
            "tripId": tripId
        };
    }

    resource function get trips() returns Trip[]|error {
        Trip[] tripList = [];
        foreach var trip in trips {
            tripList.push(trip);
        }
        return tripList;
    }

    resource function get trips/route/[string routeId]() returns Trip[]|error {
        Trip[] tripList = [];
        foreach var trip in trips {
            if (trip.routeId == routeId) {
                tripList.push(trip);
            }
        }
        return tripList;
    }

    resource function get trips/[string tripId]() returns Trip|http:NotFound|error {
        if (trips.hasKey(tripId)) {
            return trips.get(tripId);
        }
        return http:NOT_FOUND;
    }

    resource function put trips/[string tripId]/status(@http:Payload json statusUpdate) returns json|error {
        if (trips.hasKey(tripId)) {
            Trip trip = trips.get(tripId);
            string newStatus = check statusUpdate.status;
            trip.status = newStatus;
            trips[tripId] = trip;

            log:printInfo("Trip status updated: " + tripId + " -> " + newStatus);

            return {
                "success": true,
                "message": "Trip status updated successfully"
            };
        }

        return {
            "success": false,
            "message": "Trip not found"
        };
    }

    resource function post schedule/update(@http:Payload json scheduleUpdate) returns json|error {
        log:printInfo("Schedule update published");

        return {
            "success": true,
            "message": "Schedule update published successfully"
        };
    }

    resource function get health() returns json {
        return {
            "service": "transport-service",
            "status": "UP",
            "timestamp": time:utcToString(time:utcNow())
        };
    }
}