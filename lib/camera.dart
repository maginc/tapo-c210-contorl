// To parse this JSON data, do
//
//     final Camera = welcomeFromJson(jsonString);

import 'dart:convert';

Camera welcomeFromJson(String str) => Camera.fromJson(json.decode(str));

String welcomeToJson(Camera data) => json.encode(data.toJson());

class Camera {
    String method;
    Motor motor;

    Camera({
        required this.method,
        required this.motor,
    });

    factory Camera.fromJson(Map<String, dynamic> json) => Camera(
        method: json["method"],
        motor: Motor.fromJson(json["motor"]),
    );

    Map<String, dynamic> toJson() => {
        "method": method,
        "motor": motor.toJson(),
    };
}

class Motor {
    Move move;

    Motor({
        required this.move,
    });

    factory Motor.fromJson(Map<String, dynamic> json) => Motor(
        move: Move.fromJson(json["move"]),
    );

    Map<String, dynamic> toJson() => {
        "move": move.toJson(),
    };
}

class Move {
    String xCoord;
    String yCoord;

    Move({
        required this.xCoord,
        required this.yCoord,
    });

    factory Move.fromJson(Map<String, dynamic> json) => Move(
        xCoord: json["x_coord"],
        yCoord: json["y_coord"],
    );

    Map<String, dynamic> toJson() => {
        "x_coord": xCoord,
        "y_coord": yCoord,
    };
}
