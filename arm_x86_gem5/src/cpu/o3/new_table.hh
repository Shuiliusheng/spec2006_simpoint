#ifndef __CPU_NEW_TABLE_HH__
#define __CPU_NEW_TABLE_HH__

#include <list>
#include <utility>
#include <iostream>
#include <vector>

#include "base/statistics.hh"
#include "arch/types.hh"
#include "config/the_isa.hh"
#include "cpu/o3/free_list.hh"
#include "cpu/o3/regfile.hh"
#include "cpu/reg_class.hh"

class RegTable
{
public:
	unsigned ArchIntRegNum;
	unsigned ArchFloatRegNum;
	typedef struct{
		bool valid;
		TheISA::PCState pc;
	}Entry;
	using RTable = std::vector<Entry>;
	RTable intTable;
	RTable floatTable;
	
	RegTable(unsigned int_reg_num, unsigned float_reg_num)
	{
		ArchIntRegNum=int_reg_num;
		ArchFloatRegNum=float_reg_num;
		intTable.resize(ArchIntRegNum);
		floatTable.resize(ArchFloatRegNum);
	}
	
	void init()
	{
		for(int i=0;i<ArchIntRegNum;i++)
			intTable[i].valid=false;
		for(int i=0;i<ArchFloatRegNum;i++)
			floatTable[i].valid=false;
	}
	
	void lookup(const RegId& arch_reg) const
	{
		if(arch_reg.isIntReg())
		{
			assert(arch_reg.flatIndex() <= ArchIntRegNum);
			if(intTable[arch_reg.flatIndex()].valid)
			{
				TheISA::PCState pc = intTable[arch_reg.flatIndex()].pc;
				//...relativeTable operator : counter++
			}
		}
		else if(arch_reg.isFloatReg())
		{
			assert(arch_reg.flatIndex() <= ArchFloatRegNum);
			if(floatTable[arch_reg.flatIndex()].valid)
			{
				TheISA::PCState pc = floatTable[arch_reg.flatIndex()].pc;
				//...relativeTable operator : counter++
			}
		}
		else
		{
			
		}
	} 
	
/*	void addDstReg(TheISA::PCState pc, const RegId& arch_reg) const
	{
		if(arch_reg.isIntReg())
		{
			assert(arch_reg.flatIndex() <= ArchIntRegNum);
			intTable[arch_reg.flatIndex()].valid = true;
			intTable[arch_reg.flatIndex()].pc = pc;
			//...relativeTable operator : counter = 0
		}
		else if(arch_reg.isFloatReg())
		{
			assert(arch_reg.flatIndex() <= ArchFloatRegNum);
			floatTable[arch_reg.flatIndex()].valid = true;
			floatTable[arch_reg.flatIndex()].pc = pc;
			//...relativeTable operator : counter = 0
		}
		else
		{
			
		}
	}*/
	
	~RegTable(){}
};

class RelativeTable
{
public:
	RelativeTable()
	{
		
	}
	~RelativeTable(){}
};



#endif // __CPU_NEW_TABLE_HH__