import Foundation
import Observation

@Observable
public class TodoistState {
    public var projects: [TodoistProject] = []
    public var tasks: [TodoistTask] = []
    public var sections: [TodoistSection] = []

    func update(with delta: Todoist.SyncReadResponse) {
        self.update(with: delta.items)
        self.update(with: delta.projects)
        self.update(with: delta.sections)
    }
    
    func update(with delta: [TodoistSection]) {
        if self.sections.isEmpty {
            self.sections = delta
            return
        }
        for s in delta {
            if s.isDeleted {
                self.sections.removeAll(where: { $0.id == s.id })
            }
            if let index = self.sections.firstIndex(where: { $0.id == s.id }) {
                self.sections[index] = s
            } else {
                self.sections.append(s)
            }
        }
    }
    func update(with delta: [TodoistProject]) {
        if self.projects.isEmpty {
            self.projects = delta
            return
        }
        for p in delta {
            if p.isDeleted {
                self.projects.removeAll(where: { $0.id == p.id })
            }
            if let index = self.projects.firstIndex(where: { $0.id == p.id }) {
                self.projects[index] = p
            } else {
                self.projects.append(p)
            }
        }
    }
    func update(with delta: [TodoistTask]) {
        if self.tasks.isEmpty {
            self.tasks = delta
            return
        }
        for t in delta {
            if t.isDeleted {
                self.projects.removeAll(where: { $0.id == t.id })
            }
            if let index = self.tasks.firstIndex(where: { $0.id == t.id }) {
                self.tasks[index] = t
            } else {
                self.tasks.append(t)
            }
        }
    }
}
