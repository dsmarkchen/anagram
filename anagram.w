\datethis
@ Anagram.

Below is the program structure.
@c
@<includes@>@/
@<implementation@>@/
@<tests@>@/
@<main@>@/


@ Fill with test code in main. That is the normal way to use {\tt CppUnit}.
@<main@>=
@<qa\_anagram\_tests@>@/
int main(int argc, char* argv[])
{
	CppUnit::TestResult testresult;
	CppUnit::TestResultCollector collectedresults;
	
	testresult.addListener(&collectedresults);
	CppUnit::BriefTestProgressListener progress;
    testresult.addListener (&progress);
		
	CppUnit::TestRunner	runner;
	runner.addTest (qa_anagram_tests::suite ());
	
	runner.run(testresult); 
	CppUnit::CompilerOutputter compileroutputter (&collectedresults, std::cerr);
	compileroutputter.write ();
	return collectedresults.wasSuccessful () ? 0 : 1; 
}
@ @<qa\_anagram...@>+=
class qa_anagram_tests {
public:
	static CppUnit::TestSuite* suite();
};
CppUnit::TestSuite * qa_anagram_tests::suite()
{
	CppUnit::TextTestRunner runner;
	CppUnit::TestSuite *s = new CppUnit::TestSuite("qa_anagram_tests");
	s->addTest(CQA_BasicTest::suite());	
	s->addTest(CQA_AnagramTest::suite());	
	return s;

}
@ Basic help functions.
Given a positive number, calculate the permutation.
@<imple...@>+=
int perm(int n)
{
    int sum = 1;
    if (n<=1) return 1;
    for (int i = 2; i<=n;i++)
        sum *= i;
    return sum;
}

@ @<test...@>+=
class CQA_BasicTest : public CppUnit::TestCase {
    CPPUNIT_TEST_SUITE(CQA_BasicTest);
    CPPUNIT_TEST (t1);
    CPPUNIT_TEST (t2);
    CPPUNIT_TEST (t3);
    CPPUNIT_TEST_SUITE_END();

    private:
    void t1();
    void t2();
    void t3();
};

@ To test permuate function. Given a number, 4, can we get 24?

@<test...@>+=
void CQA_BasicTest::t1() 
{
    int n = perm(4);
    
    CPPUNIT_ASSERT_EQUAL(n, 24);
}

@ Another basic feature, is to determine the occarance of the charactors with given a string.

@<imple...@>+=
int seq_chars(const char*p, char* q, int qmax, int* qn, int qnmax)
{
    char c;
    char* qptr;
    int r = 0;
    memset(q, 0, qmax*sizeof(char));
    memset(qn, 0, qnmax*sizeof(int));
    while( (c=*p) != 0) {
        qptr = strchr(q,c);
        if(qptr==NULL) {
            @<append c to q and update qn@>@;
        }
        else {
            @<update qn with exist qptr@>@;
        }
        p++;
    }

    return r; /* count in q */
}
@ @<append c to q and update qn@>=
{
    int qlen = strlen(q);
    assert(qlen < qmax);
    assert(qlen < qnmax);
    q[qlen] = c;
    qn[qlen] = 1;
    r = qlen+1;
}
@ @<incl...@>+=
#include <assert.h>

@ @<update qn with exist qptr@>=
{
    int qpos = qptr-q;
    assert(qpos < qnmax);
    qn[qpos]++;
}
@ test biro only happens once.
@<test...@>+=
void CQA_BasicTest::t2() 
{
    char q[4];
    int qn[4];
    int r = seq_chars("biro", q, 4, qn, 4);
    CPPUNIT_ASSERT_EQUAL(r, 4); 
    for(int i=0; i<4; i++) { 
        CPPUNIT_ASSERT_EQUAL(qn[i], 1);
    }

}
@ Test the case for 3a 2b 1c 4d.
@<test...@>+=
void CQA_BasicTest::t3() 
{
    char q[4];
    int qn[4];
    int r = seq_chars("abbdadadcd", q, 4, qn, 4); 
    CPPUNIT_ASSERT_EQUAL(r, 4); 
    for(int i=0; i<4; i++) { 
        if(q[i] == 'a') {
            CPPUNIT_ASSERT_EQUAL(qn[i], 3);
        }
        if(q[i] == 'b') {
            CPPUNIT_ASSERT_EQUAL(qn[i], 2);
        }
        if(q[i] == 'c') {
            CPPUNIT_ASSERT_EQUAL(qn[i], 1);
        }
        if(q[i] == 'd') {
            CPPUNIT_ASSERT_EQUAL(qn[i], 4);
        }


    }
}

@ Now we declare test class.

I am not adding all test cases once, but slowly add them one by one. 

Finally it looks like this.

@<tests@>+=
class CQA_AnagramTest : public CppUnit::TestCase {
    CPPUNIT_TEST_SUITE(CQA_AnagramTest);
    CPPUNIT_TEST (t1);
    CPPUNIT_TEST (t2);
    CPPUNIT_TEST (t3);
    CPPUNIT_TEST_SUITE_END();

    private:
    void t1();
    void t2();
    void t3();
};

@ @<includes@>+=
#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestCase.h>
#include <cppunit/TestSuite.h>
#include <cppunit/TextTestRunner.h>
#include <cppunit/TestResult.h>
#include <cppunit/TestResultCollector.h>
#include <cppunit/CompilerOutputter.h>
#include <cppunit/BriefTestProgressListener.h>
#include <cppunit/extensions/TestFactoryRegistry.h>
class CQA_AnagramTest;


@ Test case one. 
Consider character 'b' it has only only  possibility output as 'b'.

@<test...@>+=
void CQA_AnagramTest::t1()
{
    char** q;
    int qmax=1;
    string sinput = "b";
    q = (char**)malloc(sizeof(char*)*qmax);
    for(int i=0; i<qmax;i++) {
        q[i] = (char*)malloc(2);
        memset(q[i], 0, 2);
    }
    int qn = anagram(sinput.c_str(), 1, q, qmax);
    
    CPPUNIT_ASSERT_EQUAL(qn, 1);
    CPPUNIT_ASSERT_EQUAL(q[0][0], 'b');    
}
@ Test case two. 
Consider character 'ab' it will generate 'ab' and 'ba'

@<test...@>+=
void CQA_AnagramTest::t2()
{
    int r1,r2;
    char** q;
    int qmax=2;
    string sinput = "ab";
    int n = strlen(sinput.c_str())+1;
    q = (char**)malloc(sizeof(char*)*qmax);
    for(int i=0; i<qmax;i++) {
        q[i] = (char*)malloc(n);
        memset(q[i], 0, n);
    }
    int qn = anagram(sinput.c_str(), 2, q, qmax);
    
    CPPUNIT_ASSERT_EQUAL(qn, 2);
    for (int i=0; i<qn; i++) {
        r1 = strcmp(q[i], "ab");
        r2 = strcmp(q[i], "ba");
        if(r1 == 0) {
            CPPUNIT_ASSERT(r2 != 0);
        }
        if(r2 == 0) {
            CPPUNIT_ASSERT(r1 != 0);
        }
    }
}



@ A input string `biro' has the following combination:

biro bior brio broi boir bori
ibro ibor irbo irob iobr iorb
rbio rboi ribo riob roib robi
obir obri oibr oirb orbi orib


Why 24 combinations? By refer to Don Knuth's book, we have the following
formula: 
    $ 4!/1!1!1!1! = 24 $
@<test...@>+=
void CQA_AnagramTest::t3()
{
    int r1,r2;
    char** q;
    int qmax=perm(4);
    string sinput = "bior";
    int n = strlen(sinput.c_str())+1;
    q = (char**)malloc(sizeof(char*)*qmax);
    for(int i=0; i<qmax;i++) {
        q[i] = (char*)malloc(n);
        memset(q[i], 0, n);
    }
    int qn = anagram(sinput.c_str(), 4, q, qmax);
    int ref[24];
    for (int i= 0;i<24;i++) 
        ref[i] = 0;
    CPPUNIT_ASSERT_EQUAL(24, qn);
     for (int i=0; i<qn; i++) {
        if(strcmp(q[i], "biro")==0) ref[i]++;
        if(strcmp(q[i], "bior")==0) ref[i]++;
        if(strcmp(q[i], "brio")==0) ref[i]++;
        if(strcmp(q[i], "broi")==0) ref[i]++;
        if(strcmp(q[i], "boir")==0) ref[i]++;
        if(strcmp(q[i], "bori")==0) ref[i]++;

        if(strcmp(q[i], "ibro")==0) ref[i]++;
        if(strcmp(q[i], "ibor")==0) ref[i]++;
        if(strcmp(q[i], "irbo")==0) ref[i]++;
        if(strcmp(q[i], "irob")==0) ref[i]++;
        if(strcmp(q[i], "iobr")==0) ref[i]++;
        if(strcmp(q[i], "iorb")==0) ref[i]++;

        if(strcmp(q[i], "rbio")==0) ref[i]++;
        if(strcmp(q[i], "rboi")==0) ref[i]++;
        if(strcmp(q[i], "ribo")==0) ref[i]++;
        if(strcmp(q[i], "riob")==0) ref[i]++;
        if(strcmp(q[i], "roib")==0) ref[i]++;
        if(strcmp(q[i], "robi")==0) ref[i]++;

        if(strcmp(q[i], "obir")==0) ref[i]++;
        if(strcmp(q[i], "obri")==0) ref[i]++;
        if(strcmp(q[i], "oibr")==0) ref[i]++;
        if(strcmp(q[i], "oirb")==0) ref[i]++;
        if(strcmp(q[i], "orbi")==0) ref[i]++;
        if(strcmp(q[i], "orib")==0) ref[i]++;
        
    }
    for (int i=0;i<24;i++) {
        if(verbose)
            cout << i << " " << ref[i] << endl;
        CPPUNIT_ASSERT_EQUAL(ref[i],1);
    }

}
@ Include the definition of the class of c++.
@<incl...@>+=
#include <vector>
#include <string>
using namespace std;
@ Implementation.
@d SMAX 256
@<imple...@>+=

int seq_chars(const char*p, char* q, int qmax, int* qn, int qnmax);

int anagram(const char* p, int pmax, char**q, int qmax)
{
    int cnt;
    int qnmax = (qmax);
    char* p2 = (char*)malloc(pmax+1);
    int* qn = (int*)malloc(sizeof(int)*qnmax);
    assert(p2!=NULL);
    assert(qn!=NULL);
    memset(p2, 0, pmax+1);
    int r = seq_chars(p, p2, pmax, qn,  qnmax);

    if(r==1){
        q[0][0] = *p2;
        return r;
    }
    if(r==2) {
        char s, s0, s1;
        s0 = p2[0];
        s1 = p2[1];
        for (int k=0; k<r; k++) {
             q[k][0] = s0;
             q[k][1] = s1;
             s = s0;
             s0 = s1;
             s1 = s;
        }
        return perm(r);
    }
    if(r>2) {
        int k = 0;
        int cnt =  perm(r);
        char s;
        cout << endl;
        int level =pmax;
        int counter = 0;
        int L;
        char ll[256];
        
       /* start with init ll*/
        memset(ll, 0, 256);
        for (int i= 0; i < level; i++)
            ll[i] = p2[i];  
restart:
        /* the first is the exist string */
        @<set q[k] from ll, update k@>@;
        
        /* set the level to the bottom and swap*/
        L = level;
        @<swap bottom@>@; 
        @<set q[k] from ll, update k@>@;
        
        
        /* when swap is done go to the up level*/
        if(L > 2) L-=2;
        if (L > 0) {
            if(verbose)
                cout << " move on to:  " << L << endl;
            s = ll[1];
            ll[1] = ll[2];
            ll[2] = s;
         }
        @<set q[k] from ll, update k@>@;
        
        L = level; /* set l to 4 again*/
        @<swap bottom@>@; 
        @<set q[k] from ll, update k@>@;
        
        if(L > 0) {
            if(verbose)
                cout << " move on to:  " << L << endl;
            s = ll[1];
            ll[1] = ll[2];
            ll[2] = s;
            L = level; /* set l to 4 again*/
        }        
        @<set q[k] from ll, update k@>@;

        @<swap bottom@>@; 
        @<set q[k] from ll, update k@>@;
        

        L = 1;
        /* move on to next head */
        counter ++;

        for (int j=0;j<level;j++) {
            ll[j] = p2[j];
        }
        s = ll[0];
        ll[0] = ll[counter];
        ll[counter] = s;
        L = level;


        if(counter < level)
            goto restart;
           

        return k;
    }
    
    return 1;
}

@ @<set q[k] from ll, update k@>=
for (int j=0;j<level;j++) {
     q[k][j] = ll[j];
}
cout << k << " : " << q[k] << endl;
k++;

@ 
@d verbose 0
@<swap bottom@>=
if(L == level) {
    if(verbose)
        cout << "do swap " << endl;
    s = ll[L-2];
    ll[L-2] = ll[L-1];
    ll[L-1] = s;
}
      

@ Index.