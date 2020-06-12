#ifndef QVECTOR_H
#define QVECTOR_H

#include "amcomdef.h"
#include <assert.h>

template <class T>
class QVector {
    
    
public:
  
    T& operator[](MUInt32 index){
        assert(index<m_count);
        return *(array+index);
    }
    
    const T* head() const { return array;}
    
    MUInt32 count() const { return m_count;}
    
    MUInt32 quota() const { return m_quota;}
    
    MBool expand(MUInt32 quota){
        if(quota<=m_quota) return MTrue;
        return realloc(quota);
    }
    
    
    
    MVoid release(){
        if(array!=MNull){
            MMemFree(MNull,array);
            array = MNull;
        }
        m_quota = m_count = 0;
    }
    
    MVoid clear(){
        if(m_count==0) return;
        MMemSet(array,0,sizeof(T)*m_count);
        m_count = 0;
    }
    
    MBool resize(MUInt32 count){
        if(count==0) return MFalse;
        if(count==m_count) return MTrue;
        if(count<m_count){
            MMemSet(array+count , 0, (m_count-count)*sizeof(T));
            m_count = count;
            return MTrue;
        }else{
            if(m_quota<count) if(!realloc(count)) return MFalse;
            MMemSet(array+m_count , 0, (count-m_count)*sizeof(T));
            m_count = count;
            return MTrue;
        }
    }
    
    MBool insertMem(const T* items, MUInt32 count ,MUInt32 index){
        assert(index<=m_count && count>0);
        MUInt32 newCount = m_count+count;
        if(newCount>m_quota){
            MUInt32 newQuota = m_quota==0?defaultQuota:m_quota*2;
            while (newQuota<newCount) newQuota*=2;
            if(!realloc(newQuota)) return MFalse;
        }
		if(m_count-index>0) MMemMove(array+index+count,array+index,sizeof(T)*(m_count-index));
        MMemCpy(array+index,items,sizeof(T)*count);
        m_count += count;
        return MTrue;
    }
    
    MBool insert(const T& item, MUInt32 index){
        return insertMem(&item,1,index);
    }
    
    MBool appendMem(const T* items, MUInt32 count){
        return insertMem(items,count,m_count);
    }
    
    MBool append(const T& itme){
        return appendMem(&itme,1);
    }
    
    const T& itemAt(MUInt32 index) const{
        assert(index<m_count);
        return *(array+index);
    }
    
    MVoid removeAt(MUInt32 index){
        assert(index<m_count);
        if(index==m_count-1){
            MMemSet(array+index, 0, sizeof(T));
            m_count--;
        }else{
            MMemMove(array+index , array+index+1, sizeof(T)* (m_count-index-1));
            MMemSet(array+(m_count-1), 0, sizeof(T));
            m_count--;
        }
    }
    
    QVector(){}
    
    QVector(MUInt32 size){
        resize(size);
    }
    ~QVector(){
        release();
    }
protected:
    MBool realloc(MUInt32 size){
        if(size<=m_quota) return MTrue;
        
        T* newArray = (T*)MMemAlloc(MNull,sizeof(T)*size);
        if(newArray==MNull) return MFalse;
        
        MMemSet(newArray,0,sizeof(size));
        if(array!=MNull){
            MMemCpy(newArray,array,sizeof(T)*m_count);
            MMemFree(MNull,array);
        }
        array = newArray;
        m_quota = size;
        return MTrue;
    }
    
private:
    QVector(const QVector &);
    QVector &operator=(const QVector &);

protected:
    const static MUInt32 defaultQuota = 5;
    MUInt32 m_count = 0;
    MUInt32 m_quota = 0;
    T* array = MNull;
};





#endif
