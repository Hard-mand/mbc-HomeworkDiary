import Buffer "mo:base/Buffer";
import Type "types";
import Result "mo:base/Result";
import Array "mo:base/Array";

actor HomeworkDiary {

    type Homework = Type.Homework;

    // Define la estructura de datos "homeworkDiary" como un Array de Homework
    var homeworkDiary = Buffer.Buffer<Homework>(0);

    // Agregar nueva tarea.
    public shared func addHomework(homework : Homework) : async Nat {
        homeworkDiary.add(homework);
        homeworkDiary.size() - 1;
    };

    // Obtener una tarea específica por id.
    public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
        if (id >= homeworkDiary.size()) {
            return #err("Invalid homework id");
        };
        return #ok(homeworkDiary.get(id));
    };

    // Actualizar el título, descripción y/o fecha de vencimiento de una tarea.
    public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
        if (id >= homeworkDiary.size()) {
            return #err("Invalid homework id");
        };
        homeworkDiary.put(id, homework);
        #ok();
    };

    // Marcar tarea como completada.
    public shared func markAsComplete(id : Nat) : async Result.Result<(), Text> {
        if (id >= homeworkDiary.size()) {
            return #err("Invalid homework id");
        };
        var currentHomework = homeworkDiary.get(id);

        let homework = homeworkDiary.remove(id);
        homeworkDiary.add({
            title = currentHomework.title;
            dueDate = currentHomework.dueDate;
            completed = true;
            description = currentHomework.description;
        });
        #ok();
    };

    // Eliminar tarea por id.
    public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
        if (id >= homeworkDiary.size()) {
            return #err("Invalid homework id");
        };
        let currentHomework = homeworkDiary.remove(id);
        #ok();
    };

    // Obtener lista de todas las tareas.
    public shared query func getAllHomework() : async [Homework] {
        Buffer.toArray(homeworkDiary);
    };

    // Obtener lista de tarea listas (No completadas).
    public shared query func getPendingHomework() : async [Homework] {
        let result = Buffer.Buffer<Homework>(0);
        Buffer.iterate<Homework>(
            homeworkDiary,
            func(homework) {
                if (not (homework.completed)) result.add(homework);
            },
        );
        Buffer.toArray(result);
    };

    // Buscar tareas en base a términos de búsqueda.
    public shared query func searchHomework(searchTerm : Text) : async [Homework] {
        let result = Buffer.Buffer<Homework>(0);
        Buffer.iterate<Homework>(
            homeworkDiary,
            func(homework) {
                if (homework.title == searchTerm or homework.description == searchTerm) result.add(homework);
            },
        );
        Buffer.toArray(result);
    };
};