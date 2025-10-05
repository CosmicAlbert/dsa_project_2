import ballerina/http;
import ballerina/log;
import ballerina/time;

type Notification record {|
    string notificationId?;
    string? passengerId;
    string notificationType;
    string title;
    string message;
    string status?;
    string createdAt?;
|};

map<Notification[]> passengerNotifications = {};
Notification[] allNotifications = [];


service /notification on new http:Listener(9005) {

    resource function get passenger/[string passengerId]() returns Notification[]|error {
        if (passengerNotifications.hasKey(passengerId)) {
            return passengerNotifications.get(passengerId);
        }
        return [];
    }

    resource function post send(@http:Payload Notification notification) returns json|error {
        string notificationId = "NOTIF" + time:utcNow()[0].toString();
        notification.notificationId = notificationId;
        notification.status = "SENT";
        notification.createdAt = time:utcToString(time:utcNow());

        allNotifications.push(notification);
        
        if (notification.passengerId is string) {
            string pid = <string>notification.passengerId;
            if (passengerNotifications.hasKey(pid)) {
                Notification[] existing = passengerNotifications.get(pid);
                existing.push(notification);
                passengerNotifications[pid] = existing;
            } else {
                passengerNotifications[pid] = [notification];
            }
        }

        log:printInfo("Notification sent: " + notificationId);

        return {
            "success": true,
            "message": "Notification sent successfully",
            "notificationId": notificationId
        };
    }

    
    resource function get all() returns Notification[]|error {
        return allNotifications;
    }

    resource function get health() returns json {
        return {
            "service": "notification-service",
            "status": "UP",
            "timestamp": time:utcToString(time:utcNow())
        };
    }
}
