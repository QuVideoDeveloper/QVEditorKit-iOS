#ifndef QVECTOR_H
#define QVECTOR_H

#include<assert.h>

template <class T>
class QVector {
    
    
public:
  
    T& operator[](MUInt32 index){
		assert(index<m_count);
        return *(array+index);
    }
    
    const T& operator[](MUInt32 index) const{
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
            delete [] array;
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
            memset(array+count , 0, (m_count-count)*sizeof(T));
            m_count = count;
            return MTrue;
        }else{
            if(m_quota<count) if(!realloc(count)) return MFalse;
			memset(array+m_count , 0, (count-m_count)*sizeof(T));
            m_count = count;
            return MTrue;
        }
    }
    

    MBool insert(const T& item, MUInt32 index){
		assert(index <= m_count);
		MUInt32 newCount = m_count + 1;
		if (newCount>m_quota) {
			MUInt32 newQuota = m_quota == 0 ? defaultQuota : m_quota * 2;
			while (newQuota<newCount) newQuota *= 2;
			if (!realloc(newQuota)) return MFalse;
		}
		if (m_count - index>0) memmove(array + index + 1, array + index, sizeof(T)*(m_count - index));
		*(array + index) = item;
		m_count += 1;
		return MTrue;
    }
    
	MBool append(const T& itme) {
		return insert(itme, m_count);
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
    QVector<T>& operator=(const QVector<T>& src){
        resize(src.count());
        int size = count();
        if(size>0) memcpy(this->array, src.head(), sizeof(T)*size);
        return *this;
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
        
        T* newArray = new T[size];
        if(newArray==MNull) return MFalse;
        
        memset(newArray,0,sizeof(size));
        if(array!=MNull){
            memcpy(newArray,array,sizeof(T)*m_count);
            delete [] array;
        }
        array = newArray;
        m_quota = size;
        return MTrue;
    }
    
private:
    QVector(const QVector &);

protected:
    const static MUInt32 defaultQuota = 5;
    MUInt32 m_count = 0;
    MUInt32 m_quota = 0;
    T* array = MNull;
};

class CstrHolder : public QVector<char*> {

public:

	char*  createWithLen(int len) {
		char* newItm = nullptr;
		append(newItm);
		char**hold = &(*this)[count() - 1];

		*hold = new char[len];
		memset(*hold, 0, len * sizeof(char));
		return *hold;
	}

	char*  createWithStr(const char* str) {
		if (str == nullptr) return nullptr;
		int len = strlen(str);
		MChar* strp = createWithLen(len + 1);

		memcpy(strp, str,sizeof(char)*len);
		return strp;
	}

	void destroy() {
		for (int i = 0; i < count(); i++) {
			MChar* &item = (*this)[i];
			if (item) delete[] item;
			item = nullptr;
		}

		QVector<char*>::release();
	}


	CstrHolder() :QVector<char*>() {}
	~CstrHolder() {
		destroy();
	}

};



#endif
