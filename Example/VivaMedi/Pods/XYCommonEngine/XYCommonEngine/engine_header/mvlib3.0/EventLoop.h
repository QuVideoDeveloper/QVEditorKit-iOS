/*----------------------------------------------------------------------------------------------
 *
 * This file is QuVideo's property. It contains QuVideo's trade secret, proprietary and
 * confidential information.
 *
 * The information and code contained in this file is only for authorized QuVideo employees
 * to design, create, modify, or review.
 *
 * DO NOT DISTRIBUTE, DO NOT DUPLICATE OR TRANSMIT IN ANY FORM WITHOUT PROPER AUTHORIZATION.
 *
 * If you are not an intended recipient of this file, you must not copy, distribute, modify,
 * or take any action in reliance on it.
 *
 * If you have received this file in error, please immediately notify QuVideo and
 * permanently delete the original and any copy of any file and any printout thereof.
 *
 *----------------------------------------------------------------------------------------------*/

/*
 * EventLoop.h
 *
 * Event Loop
 *
 * Code History
 *
 *
 * --2017-03-31 Wang Xiaoming
 *   initial version
 *
 */
#ifndef __EVENT_LOOP_H
#define __EVENT_LOOP_H

#include <list>
#include <stdint.h>
#include <amcomdef.h>
#include <mv2inc.h>
#include <mkernelobj.h>
#include <atomic>

#include <functional>

typedef struct _Event{
    _Event(): what(-1), arg1(0), arg2(0), arg3(0), arg4(0){}
    int what;
    int arg1, arg2;
    int64_t arg3, arg4;
}Event;


class EventLoop{
public:
    static EventLoop* getInstance(){
        static EventLoop loop;
        return &loop;
    }

    void setHandler(void(*handler)(const Event& event, void* arg), void* arg){
        m_Handler = handler;
        m_pArg = arg;
    }

    void setHandler(std::function<void(const Event& event)> func_handler){
        m_funcHandler = func_handler;
    }

    MRESULT start();
    MRESULT stop();

    void postEvent(const Event& event);

    virtual ~EventLoop();

    EventLoop();
    
private:
    
    static MDWord threadEntry(MVoid * pParam);
    void threadLoop();

private:
    std::list<Event> m_queue;
    MHandle m_pThread;
    CMMutex m_mutex;
    std::atomic<MBool> m_bStarted;
    void(*m_Handler)(const Event& event, void* arg);
    void* m_pArg;
    std::function<void(const Event& event)> m_funcHandler;
};

#endif  //  __EVENT_LOOP_H
