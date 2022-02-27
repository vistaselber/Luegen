//
//  Event.swift
//  HelloWorldApp
//
//  Created by Jan Hummel on 06.10.20.
//  Copyright © 2020 Jan Hummel. All rights reserved.
//

//https://gist.github.com/blixt/08434b74f0c043f83fcb
// Thema mit Method, Void no Event data:
//https://forums.swift.org/t/calling-void-with-void/6292

import Foundation

private class Invoker<EventData> {
    weak var listener: AnyObject?
    let closure: (EventData) -> Bool
    //let id: UUID//= UUID()
    var name: String

    init<Listener : AnyObject>(listener: Listener, method: @escaping (Listener) -> (EventData) -> Void, name: String) {
        self.listener = listener
        self.closure = {
            [weak listener] (data: EventData) in
            guard let listener = listener else {
                return false
            }
            method(listener)(data)
            return true
        }
        //self.id = UUID.init()
        self.name = name
    }
}

class Event<EventData> {
    private var invokers = [Invoker<EventData>]()

    /// Adds an event listener, notifying the provided method when the event is emitted.
    func addListener<Listener : AnyObject>(listener: Listener, method: @escaping ((Listener) -> (EventData) -> Void), name: String) {
        let invokerToBeAdded = Invoker(listener: listener, method: method, name: name)
        var invokerIsNew: Bool = true
        
        /*if invokerToBeAdded.name == "YourTurn.onYourTurn"{ //Gamemaster.onFourOfAKind
            print("!!!Achtung Listener !!!")
        }*/
        
        /*//nur 1x den gleichen Listener für ein Event registrieren
        for invoker in invokers{
            //print("Invoker:\(invoker.id.uuidString) vs. InvokerToBeAdded:\(invokerToBeAdded.id.uuidString)")
            if invoker.name == invokerToBeAdded.name {
                invokerIsNew = false
                print("Invoker \(invokerToBeAdded.name) gibt es schon...")
            }
        }*/
        
        if invokerIsNew {
            //print("[Event.addListener]: neuer Invoker=\(invokerToBeAdded.name)")
            invokers.append(invokerToBeAdded)
        }
    }

    /// Removes the object from the list of objects that get notified of the event.
    func removeListener(listener: AnyObject) {
        invokers = invokers.filter {
            guard let current = $0.listener else {
                return false
            }
            return current !== listener
        }
    }

    /// Publishes the specified data to all listeners via the global utility dispatch queue.
    func emit(data: EventData) {
        //let queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        let queue = DispatchQueue.global(qos: .default)//background
        let queue2 = DispatchQueue.global(qos: .userInteractive)
        
        //let backgroundQueue = OperationQueue()
        //let queue = DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){

        for invoker in invokers {
            /*queue.async() {
                // TODO: If this returns false, we should remove the invoker from the list.
                invoker.closure(data)
            }*/

            //backgroundQueue.addOperation { invoker.closure(data) }
            //queue2.sync() { invoker.closure(data) }
            
            var dispatchWorkItem = DispatchWorkItem{
                invoker.closure(data)
            }
            queue.asyncAndWait(execute: dispatchWorkItem)
            
            //https://betterprogramming.pub/a-deep-dive-into-dispatchworkitem-274548357dea
            /*dispatchWorkItem.notify(queue: main){
                notify
            }*/
            //DispatchQueue.global().asyncAndWait(execute: dispatchWorkItem)
            /*
            queue.asyncAfter(deadline: .now() + 0.5){
                invoker.closure(data)
            }*/
            /*
            RunLoop.main.perform {
                invoker.closure(data)
            }
            RunLoop.main.run()
            */
        }
    }
}

